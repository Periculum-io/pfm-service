import pandas as pd
import pandas as pd        
from helpers import create_salary_or_other_income_or_recurrent_expense_df, compute_number_of_transacting_month, compute_salary_frequency, forecast_salary_day
from keywords import salary_keywords

pd.options.mode.chained_assignment = None


class IncomeAnalysis(object):
    """
        This class details the methods needed for carrying out Income analysis on the customer's bank statement
    """

    def __init__(self, data, statement_type, account_name):
        self.data = data
        self.statement_type = statement_type.lower()
        self.account_name = account_name

    def calculate_salary(self, category_flag):
        summary = {}
        self.predicted_salary = create_salary_or_other_income_or_recurrent_expense_df(self.data, category_flag)

        self.predicted_salary = self.predicted_salary[
                                    ~self.predicted_salary['description'].str.contains(str(self.account_name))]
        self.predicted_salary[["amount", "balance"]] = self.predicted_salary[["amount", "balance"]].astype(float)
        self.predicted_salary["key"] = "salary"


        if (self.statement_type != "consumer") or (len(self.predicted_salary) == 0) or (len(self.predicted_salary) == 1 and not any([salary_keywords in x for x in self.predicted_salary['description']])):
                    summary["average_predicted_salary"] = 0.0
        else:
            salary_df = self.predicted_salary[["date", "description", "amount"]]
            salary_df['date'] = pd.to_datetime(salary_df['date'])
            no_unique_months = salary_df['date'].dt.month.nunique()
            salary_df["year"] = pd.to_datetime(salary_df["date"]).dt.year
            salary_df["year"] = salary_df["year"].apply(lambda x: str(x))
            salary_df['month_name'] = salary_df['date'].dt.month_name()

            cats = ['January', 'February', 'March', 'April','May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
            # sort month name
            salary_df['month-name'] = pd.Categorical(salary_df['month_name'],categories=cats, ordered=True)
            salary_df = salary_df.sort_values(["year", "month-name"])
            salary_df = salary_df[['year', 'month-name', 'amount', 'description']]
            salary_df = salary_df.to_dict(orient='records')
            summary["salary_transactions"] = salary_df

            try:
                for index, row in self.predicted_salary.iterrows():
                    if row['difference_in_days'] > 16:
                        summary["average_predicted_salary"] = round(float(self.predicted_salary.groupby(pd.Grouper(key='date', freq="M")).sum().sum()["amount"]) / len(self.predicted_salary), 2)
                    else:
                        summary["average_predicted_salary"] = round(float(self.predicted_salary.groupby(pd.Grouper(key='date', freq="M")).sum().sum()["amount"]) / (no_unique_months), 2)
            except:
                summary["average_predicted_salary"] = 0
            summary["number_of_salary_payments"] = int(len(self.predicted_salary))
        return summary, self.predicted_salary

