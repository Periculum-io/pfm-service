import re
import pandas as pd
import numpy as np
import math
from collections import Counter
from keywords import salary_keywords, keywords_to_remove_for_salary, keywords_to_remove_for_other_income
import stop_words
list_stopwords = set(stop_words.get_stop_words("en"))
from collections import Counter
from fuzzywuzzy import fuzz, process


salary_variables = {
    "transactionAmountThreshold": 0.13,
    "minDifferenceInPaymentDays": 18,
    "maxDifferenceInPaymentDays": 40,
    "thresholdForDifferenceInDaysOccurrence": 0.60,
    "amountGreaterThan": 30000.00,
}


def clean_description(data, category_flag):
    data["description"] = data["description"].str.lower()

    data["description"] = data["description"].apply(lambda x: " ".join(re.split("[&%#+><|`~?;,:/@\-()=_!]", str(x))))
    data = data[data.type.isin(["credit", "C", "c", "Credit", "CREDIT"])]
        
    return data[(data["amount"] > category_flag["amountGreaterThan"])]


# conditions for logic below(needed to fill the index difference_in_days for the index transaction):
# 1. checks if payment day for index transaction is +-3 days away from the modal day for other non-index transactions or
# 2. checks if the salary keywords are in the index transaction narration
# 3. checks if the amount for index transaction is +- 10% away from the mean amount of other non-mean trans
# 4. if any of the three conditions return true then difference_in_days for index transaction is set to 30 else 0
# 5. I used the first len condition to handle scenarios when only a single transaction is returned
# (i.e. no data.iloc[1:] but only data.iloc[0]). In such scenario, the difference_in_days is set to 0

def assign_difference_in_days_for_index_transaction(data):
    if (
            (data.iloc[1:]["date"].dt.day.mode()[0] - 3) <= data.iloc[0]["date"].day <=
            (data.iloc[1:]["date"].dt.day.mode()[0] + 3)
            or any(x in data.iloc[0]["description"] for x in salary_keywords)
            or (
            (data.iloc[1:]["amount"].mean() * 0.9) <= data.iloc[0]["amount"] <= (data.iloc[1:]["amount"].mean() * 1.1))
    ):
        return 30
    else:
        return 0


# for computing average mean after getting difference in days
def compute_average_date_flag(data, category_flag):
    data["date_flag"] = data["difference_in_days"].apply(lambda x: 1 if (
            category_flag["maxDifferenceInPaymentDays"] >= x >= category_flag["minDifferenceInPaymentDays"]) else 0)
    if data["date_flag"].mean() >= category_flag["thresholdForDifferenceInDaysOccurrence"]:
        return data
    else:
        data = pd.DataFrame(columns=data.columns)
        data["modal_class"] = ""
        return data


# function selects observations within the recommended max and min values.. Then, sorts by date, compute difference
# in days
def get_recommended_max_min_df(data, index, modal_class, category_flag):
    recommended_max_val = data["amount"].value_counts().index[:5].values[index] * (
            1 + category_flag["transactionAmountThreshold"])
    recommended_min_val = data["amount"].value_counts().index[:5].values[index] * (
            1 - category_flag["transactionAmountThreshold"])

    data = data[data["amount"].apply(lambda x: recommended_min_val <= x <= recommended_max_val)]
    data["modal_class"] = modal_class
    data["date"] = pd.to_datetime(data["date"])

    data = data.sort_values("date", ascending=True)

    data["difference_in_days"] = data.groupby("modal_class")["date"].diff().fillna(pd.Timedelta("0 days")).dt.days

    return data


def df_to_return_if_data_empty(data, index):
    data = pd.DataFrame(columns=data.columns)
    data["modal_class"] = index
    data["date_flag"] = ""
    return data


# CODE STARTS BELOW ---->>>>

# One - This function filters transaction_narration and returns all rows where the 10 most occuring keywords occur
def filter_by_transaction_narration(data, category_flag):
    try:
        filter_one = clean_description(data, category_flag)
        # select top ten keywords
        most_occuring = [values[0] for values in Counter(" ".join(filter_one["description"]).split()).most_common(15)]

        search_list = r"{}".format("|".join(most_occuring)).replace(")", "").replace("(", "").replace("*", "").replace(
            "\\", "").replace("/", ""). \
            replace(".", "").replace("[", "").replace("]", "").replace("+", "").replace("?", "")

        df = filter_one[filter_one["description"].str.contains(search_list)]

        if category_flag == salary_variables:
            # filter by keyword related to loan, gambling e.t.c to remove them from the dataframe.
            # This is for salary computation
            return df[~df.description.str.contains("|".join(keywords_to_remove_for_salary))]
        # elif category_flag == other_income_variables:
        #     df = df[~df["description"].str.contains(salary_keywords)]
        #     return df[~df.description.str.contains("|".join(keywords_to_remove_for_other_income))]
        else:
            return df
    except TypeError:
        print("you can only filter narration for a pandas dataframe not (list,dict, tuple or set)")

## using the fuzzywuzzy python library to check for similarity in transaction description
def fuzzy_wuzzy_check(data, category_flag):
    if category_flag == salary_variables:
        if len(data) == 0:
            return pd.DataFrame(columns=data.columns)
        else:
        ## don't want to distort the original data
            data_without_stop_words = data.copy()

            data_without_stop_words["description"] = data_without_stop_words["description"].apply(lambda x: " ".join([word for word in x.split() if word not in list_stopwords]))
            data_without_stop_words["description"] = data_without_stop_words['description'].replace({'\d':''}, regex = True)        
            top_occuring_keywords = " ".join([values[0] for values in Counter(" ".join(data_without_stop_words["description"]).split()).most_common(3)])
            
            unique_descriptions = data_without_stop_words['description'].unique().tolist()

            fuzzy_df = pd.DataFrame(process.extract(top_occuring_keywords, unique_descriptions, scorer=fuzz.partial_ratio)).rename(columns = {0:'description', 1:'fuzzy_match_ratio'})    
            if fuzzy_df['fuzzy_match_ratio'].mean() > 47:
                return data
            else:
                return pd.DataFrame(columns=data.columns)
    else:
        return data
            # return fuzzy_df

# Two - This function filters by amount and returns the first most occuring transactions
# (plus transactions that are +-13% away from first_modal amounts)
def filter_by_first_modal(data, category_flag):
    if data.empty:
        return df_to_return_if_data_empty(data, "One")
    # I implemented the max logic to capture cases where the transaction amount is unique
    # (i.e. when no two transaction amounts are the same)
    elif max(data["amount"].value_counts()) == 1:
        recommended_max_val_1 = np.percentile(data["amount"], 80) * (1 + category_flag["transactionAmountThreshold"])
        recommended_min_val_1 = np.percentile(data["amount"], 80) * (1 - category_flag["transactionAmountThreshold"])
        first_modal = data[data["amount"].apply(lambda x: recommended_min_val_1 <= x <= recommended_max_val_1)]
        first_modal["modal_class"] = "One"

        if first_modal.empty:
            first_modal = pd.DataFrame(columns=data.columns)
            first_modal["date_flag"] = ""
        else:
            first_modal = first_modal
            first_modal["date"] = pd.to_datetime(first_modal["date"])
            first_modal = first_modal.sort_values("date", ascending=True)

            first_modal["difference_in_days"] = (
                first_modal.groupby("modal_class")["date"].diff().fillna(pd.Timedelta("0 days")).dt.days)

        if len(first_modal) > 1:
            # calls the assign_difference_in_days_for_index_transaction function for assigning difference_in_days value
            # to index transaction
            first_modal.iloc[0, -1] = assign_difference_in_days_for_index_transaction(first_modal)
            first_modal = compute_average_date_flag(first_modal, category_flag)
        else:
            # empty dataframe
            first_modal = pd.DataFrame(columns=data.columns)

        return fuzzy_wuzzy_check(first_modal, category_flag)

    else:
        first_modal = get_recommended_max_min_df(data, 0, "One", category_flag)
        first_modal.iloc[0, -1]  = assign_difference_in_days_for_index_transaction(first_modal)
        first_modal =  compute_average_date_flag(first_modal, category_flag)
        return fuzzy_wuzzy_check(first_modal, category_flag)


# Three - This function filters by amount and returns the second most occuring transactions
# (plus transactions that are +-13% away from second_modal amounts)
def filter_by_second_modal(data, category_flag):
    # defaulting any dataframe with len of 1 to empty because I already handled that in the first_modal logic
    if len(data["amount"].value_counts()) == 1 or data.empty:
        return df_to_return_if_data_empty(data, "Two")
    else:
        second_modal = get_recommended_max_min_df(data, 1, "Two", category_flag)
        if len(second_modal) > 1:
            # calls the assign_difference_in_days_for_index_transaction function for assigning difference_in_days
            # value to index transaction
            second_modal.iloc[0, -1]  = assign_difference_in_days_for_index_transaction(second_modal)
        else:
            second_modal.iloc[0, -1]  = 0

        second_modal =  compute_average_date_flag(second_modal, category_flag)
        return fuzzy_wuzzy_check(second_modal, category_flag)


# Four - This function filters by amount and returns the third most occurring transactions
# (plus transactions that are +-13% away from third_modal amounts)
def filter_by_third_modal(data, category_flag):
    if len(data["amount"].value_counts()) <= 2 or data.empty:
        return df_to_return_if_data_empty(data, "Three")
    else:
        third_modal = get_recommended_max_min_df(data, 2, "Three", category_flag)

        if len(third_modal) > 1:
            third_modal.iloc[0, -1]  = assign_difference_in_days_for_index_transaction(third_modal)
        else:
            third_modal.iloc[0, -1]  = 0

        third_modal = compute_average_date_flag(third_modal, category_flag)
        return fuzzy_wuzzy_check(third_modal, category_flag)


# Five - This function filters by amount and returns the fourth most occuring transactions
# (plus transactions that are +-13% away from fourth_modal amounts)
def filter_by_fourth_modal(data, category_flag):
    if len(data["amount"].value_counts()) <= 3 or data.empty:
        return df_to_return_if_data_empty(data, "Four")
    else:
        fourth_modal = get_recommended_max_min_df(data, 3, "Four", category_flag)

        if len(fourth_modal) > 1:
            fourth_modal.iloc[0, -1]  = assign_difference_in_days_for_index_transaction(fourth_modal)
        else:
            fourth_modal.iloc[0, -1] = 0

        fourth_modal = compute_average_date_flag(fourth_modal, category_flag)
        return fuzzy_wuzzy_check(fourth_modal, category_flag)


# Six - This function filters by amount and returns the fifth most occuring transactions
# (plus transactions that are +-13% away from fifth_modal amounts)
def filter_by_fifth_modal(data, category_flag):
    if len(data["amount"].value_counts()) <= 4 or data.empty:
        return df_to_return_if_data_empty(data, "Five")
    else:
        fifth_modal = get_recommended_max_min_df(data, 4, "Five", category_flag)

        if len(fifth_modal) > 1:
            fifth_modal.iloc[0, -1] = assign_difference_in_days_for_index_transaction(fifth_modal)
        else:
            fifth_modal.iloc[0, -1] = 0

        fifth_modal = compute_average_date_flag(fifth_modal, category_flag)
        return fuzzy_wuzzy_check(fifth_modal, category_flag)
       


# Seven- This function concatenates the first five modal results and then sort the dataframe by modal_class
def combine_five_modes(first, second, third, fourth, fifth):
    second_filtered = (
        pd.concat([first, second, third, fourth, fifth]).sort_values(by=["modal_class"]).reset_index().drop("index",
                                                                                                            axis=1))
    return second_filtered


# Eight - This function removes all duplicates using the transaction date and narration
def drop_duplicates(data):
    return data.drop_duplicates(subset=["date", "description"], keep="last")


# Nine - This function filters by the transaction amount, returning all statements that are +/- 13% away from the 95th
# percentile value
# I had to increase the threshold here because it's most likely certain that values returned will be recurrent and
# salaries
# I would have used the modal value but not a best approach because not all modal amount turns out to be salary. You
# can have a salary appearing maybe twice while a non-salary appears six times e.t.c
def filter_by_transaction_amount(data, category_flag):
    if data.empty:
        return pd.DataFrame(columns=data.columns)
    else:
        recommended_max_final_1 = np.percentile(data["amount"], q=95) * (
                1 + category_flag["transactionAmountThreshold"])
        recommended_min_final_1 = np.percentile(data["amount"], q=95) * (
                1 - category_flag["transactionAmountThreshold"])
        return data[data["amount"].apply(lambda x: recommended_min_final_1 <= x <= recommended_max_final_1)]


# Ten - This function filters by actual salary keywords. The idea is to combine actual salary with the third_filtered
# and then drop duplicates
#  Sometimes, salaries will have keywords. Other times, It won't have keywords. This is me just implementing different
#  ideas
def filter_by_salary_keywords(data, category_flag):
    data = clean_description(data, category_flag)

    actual_salary = data[data["description"].str.contains(salary_keywords)]

    if actual_salary.empty:
        actual_salary = pd.DataFrame(columns=data.columns)
        actual_salary["modal_class"] = "Six"
        actual_salary["date_flag"] = ""
        return actual_salary
    else:
        actual_salary = actual_salary
        actual_salary["modal_class"] = "Six"
        actual_salary["date"] = pd.to_datetime(actual_salary["date"])
        return actual_salary


# this function works for other income transactions alone. We want to be able to pick commission, bonus, allowance e.t.c
def filter_by_other_income_keywords(data, category_flag):
    data = clean_description(data, category_flag)
    # filter by the loan disbursements keywords and others (removing observations that have those keywords)
    data = data[~data.description.str.contains("|".join(keywords_to_remove_for_other_income))]

    other_income_keywords = r"commission|bonus|allowance|interest\s*on|13th\s*month"

    other_income = data[data["description"].str.contains(other_income_keywords)]

    if other_income.empty:
        other_income = pd.DataFrame(columns=data.columns)
        other_income["modal_class"] = "Six"
        other_income["date_flag"] = ""
        return other_income
    else:
        other_income = other_income
        other_income["modal_class"] = "Six"
        other_income["date"] = pd.to_datetime(other_income["date"])
        return other_income


# Eleven - This function combines third_filtered (output from first to fifth modal class, filtered by transacted amount)
# and actual_salary transactions
def combine_both_outputs(first, second):
    return pd.concat([first, second])


# function for estimating probable salary payment day
def forecast_salary_day(salary_df):
    if salary_df.empty:
        return None
    else:
        salary_df["date"] = pd.to_datetime(salary_df["date"])
        salary_df['day'] = salary_df['date'].dt.day
        salary_df['day_adj'] = np.where(salary_df['day'] <= 9, 30+salary_df['day'], salary_df['day'])
        salary_date = math.floor(salary_df['day_adj'].median()) 
        if salary_date > 31:
            return salary_date - 31
        else:
            return salary_date


# function for computing salary frequency
def compute_salary_frequency(data):
    if len(data[data["key"] == "salary"]) <= 0:
        return None
    elif max(pd.to_datetime(data[data["key"] == "salary"]["date"]).dt.month.value_counts()) == 1:
        return "1"
    elif max(pd.to_datetime(data[data["key"] == "salary"]["date"]).dt.month.value_counts()) > 1:
        return ">1"
    
def compute_number_of_transacting_month(data):
# get the months
    data['days_in_month'] = pd.to_datetime(data["date"]).dt.daysinmonth
    data["month"] = pd.to_datetime(data["date"]).dt.month
    data["month"] = data["month"].apply(lambda x: str(x))
    
    # get the years
    data["year"] = pd.to_datetime(data["date"]).dt.year
    data["year"] = data["year"].apply(lambda x: str(x))
    data['month_name'] = data['date'].dt.month_name()

    # concatenate month and year
    data["month_year"] = data[["month", "year"]].agg("/".join, axis=1)

    # logic for number of transacting months
    number_of_days_in_month = 31
    half_month = 15.5
    start_date = pd.to_datetime(data["date"].min()).date()
    end_date = pd.to_datetime(data["date"].max()).date()
    diff_in_days = (end_date - start_date).days
    number_of_days_in_period = diff_in_days // number_of_days_in_month
    remainder_of_days_in_period = diff_in_days % number_of_days_in_month
    
    if remainder_of_days_in_period == 0:
      number_of_transacting_months = number_of_days_in_period
    elif number_of_days_in_period == 0:
        number_of_transacting_months = 1
    elif remainder_of_days_in_period <= half_month:
        number_of_transacting_months = number_of_days_in_period + 0.5
    elif remainder_of_days_in_period > half_month:
        number_of_transacting_months = number_of_days_in_period + 1
    return number_of_transacting_months
   

def create_salary_or_other_income_or_recurrent_expense_df(data, category_flag):
        first_filtered = filter_by_transaction_narration(data, category_flag)
        final_first_modal = filter_by_first_modal(first_filtered, category_flag)  # first modal value
        final_second_modal = filter_by_second_modal(first_filtered, category_flag)  # second modal value
        final_third_modal = filter_by_third_modal(first_filtered, category_flag)  # third modal value
        final_fourth_modal = filter_by_fourth_modal(first_filtered, category_flag)  # fourth modal value
        final_fifth_modal = filter_by_fifth_modal(first_filtered, category_flag)  # fifth modal value
        second_filtered = combine_five_modes(final_first_modal, final_second_modal, final_third_modal, final_fourth_modal, final_fifth_modal)  # combine all five modal data
        second_filtered = drop_duplicates(second_filtered)  # remove duplicates
        third_filtered = filter_by_transaction_amount(second_filtered, category_flag)
        if category_flag == salary_variables:
            actual_salary_filter = filter_by_salary_keywords(data, category_flag)
            fourth_filtered = combine_both_outputs(third_filtered, actual_salary_filter)
            final_data = filter_by_transaction_amount(fourth_filtered, category_flag)
            # print(final_data)
            unduplicated_data = drop_duplicates(fourth_filtered).sort_values("date").reset_index().drop("index", axis=1)
        # elif category_flag == other_income_variables:
        #     other_income_filter = filter_by_other_income_keywords(data, category_flag)
        #     fourth_filtered = combine_both_outputs(third_filtered, other_income_filter)
        #     unduplicated_data = drop_duplicates(fourth_filtered)
        #     unduplicated_data = unduplicated_data.sort_values("date").reset_index().drop("index", axis=1)
        # elif category_flag == recurring_expense_variables:
        #     unduplicated_data = drop_duplicates(third_filtered)
        #     unduplicated_data = unduplicated_data.sort_values("date").reset_index().drop("index", axis=1)
        #     unduplicated_data['date'] = pd.to_datetime(unduplicated_data['date'])
        return unduplicated_data