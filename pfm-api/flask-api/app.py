import json
import stop_words
from flask import Flask, make_response
from flask import jsonify
from flask import request
import numpy as np
import pandas as pd
from preprocessing import preprocessing_layer
from keywords import *
from keywords import salary_keywords
from helpers import create_salary_or_other_income_or_recurrent_expense_df, compute_number_of_transacting_month, compute_salary_frequency, forecast_salary_day
from helpers import salary_variables, other_income_variables
from collections import Counter

# Keycloak
import jwt
import datetime
from functools import wraps
from flask_oidc  import OpenIDConnect

app = Flask("periculum-pfm-api")
app.debug = True

app.config.update({
    'SECRET_KEY': 'my_secret',
    'TESTING': True,
    'DEBUG': True,
    'OIDC_CLIENT_SECRETS': 'client_secrets.json',
    'OIDC_OPENID_REALM': 'local',
    'OIDC_INTROSPECTION_AUTH_METHOD': 'bearer',
    'OIDC-SCOPES': ['openid'],
    'OIDC_INTROSPECTION_AUTH_METHOD': 'client_secret_post',
    'OIDC_TOKEN_TYPE_HINT': 'access_token'
})

oidc = OpenIDConnect(app)

def bad_request(message):
    response = {
      'message': message
    }
    return response, 400

def server_error():
    response = jsonify({'message': 'Something went wrong in the server. If the problem persists please contact Periculum'})
    return response, 500

def token_required(f):
   @wraps(f)
   def decorator(*args, **kwargs):
      token = None
      if 'Authorization' in request.headers:
         data = request.headers['Authorization']
         token = str.replace(str(data), 'Bearer ', '')
      if not token:
         return jsonify({'message': 'a valid token is missing'})
      try:
        data2 = jwt.decode(token, verify=False)
        print(data2['clientId'])
        print(data2['tenant'])
      except:
        return bad_request("Token does not have reqiured claims")
      return f(*args, **kwargs)
   return decorator

@app.route("/", methods=["GET"])
def index():
    return jsonify({"status": "success", "message": "API Running"})


@app.route('/healthz', methods = ['GET'])
#@oidc.accept_token(require_token=True)
#@token_required
def health():
    return jsonify(
      application='Prod Periculum PFM API',
      version='1.0.0'
    )


@app.route("/analytics", methods=["POST"])
def process():

    # get data
    query = request.json
    account_name = query['account_name']

    df = pd.DataFrame(query['transactions'])
    data = df.copy()
 
    def pfm_variables(data, salary_variables, other_income_variables):
        summary = {}
        data = preprocessing_layer(data)
        debit_transactions = data[data["type"] == "debit"]
        credit_transactions = data[data["type"] == "credit"]
        if len(data) == 0:
            summary["total_inflow"] = 0
            summary["total_outflow"] = 0
            summary['average_monthly_expenses'] = 0
            summary['average_monthly_income'] = 0
            summary["transfers_out"] = 0
            summary["atm_withdrawals"] = 0
            summary["pos_spend"] = 0
            summary["charges_and_stampduty"] = 0
            summary["top_billers"] = 0
            summary["top_beneficiaries"] = None
            summary["savings_and_investment"] = None
            summary["airtime"] = None
            summary["transportation"] = 0
            summary["internet_data"] = None
            summary["tv_and_streaming_subscription"] = 0
            summary["foods_and_drinks"] = 0
            summary["bars_lounges_club"] = 0
            summary["grocery_and_malls"] = 0
            summary["electricity"] = 0
            summary["waste_and_water"] = 0
            summary["online_and_web_purchases"] = None
            summary["gambling"] = None
            summary["loan_amount"] = None
            summary["loan_repayment"] = None
            summary["health"] = None
            summary["fitness"] = None
            summary["religious_organization"] = 0
            summary["insurance"] = None
            summary["miscellaneous"] = None
            summary["self_transfer"] = None
            summary['average_predicted_salary'] = 0
            summary['salary_transactions'] = None
            summary['bonuses_and_allowances'] = 0
            summary['bonuses_and_allowances_transactions'] = None
            summary['most_frequent_credit_transfer'] = None
            summary['most_frequent_debit_transfer'] = None
            return summary
        else:
            if len(credit_transactions) == 0:
                summary["total_inflow"] = 0
                summary["average_monthly_income"] = 0
            else:
                summary["total_inflow"] = round(
                    float(data[data["type"] == "credit"]["amount"].sum()), 2)
                summary["average_monthly_income"] = round(float(
                        data[data["type"] == "credit"].groupby(pd.Grouper(key='date', freq="M")).sum().reset_index()[
                            "amount"].mean()), 2)

            if len(debit_transactions) == 0:
                summary["total_outflow"] = 0
            else:
                summary["total_outflow"] = round(float(data[data["type"] == "debit"]["amount"].sum()),
                                                            2)
            atm_withdrawals = debit_transactions[debit_transactions['description'].str.contains(atm_keywords)]
            summary['count_of_atm_withdrawals_transactions'] = len(atm_withdrawals)
            summary["atm_withdrawals"] = round(float(atm_withdrawals.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2) 
            summary['atm_withdrawal_transactions'] = atm_withdrawals[['date', 'amount', 'description']].to_dict(orient='records')

            pos_spend = debit_transactions[debit_transactions['description'].str.contains(pos_keywords)]
            summary['count_of_pos_transactions'] = len(pos_spend)
            summary["pos_spend"] = round(float(pos_spend.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2) 
            summary['pos_transactions'] = pos_spend[['date', 'amount', 'description']].to_dict(orient='records')

            charges_and_stamp_duty = debit_transactions[debit_transactions['description'].str.contains(charges_and_stamp_duty_keywords)]
            summary['count_of_charges_and_stamp_transactions'] = len(charges_and_stamp_duty)
            summary["charges_and_stamp_duty"] = round(float(charges_and_stamp_duty.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2) 
            summary['charges_and_stamp_duty_transactions'] = charges_and_stamp_duty[['date', 'amount', 'description']].to_dict(orient='records')

            savings_and_investments = debit_transactions[debit_transactions['description'].str.contains(savings_and_investments_keyword)]
            summary['count_of_savings_and_investment_transactions'] = len(savings_and_investments)
            summary["savings_and_investment"] = round(float(savings_and_investments.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2) 
            summary['savings_and_investment_transaction'] = savings_and_investments[['date', 'amount', 'description']].to_dict(orient='records')

            airtime = debit_transactions[debit_transactions['description'].str.contains(airtime_keywords)]
            summary['count_of_airtime_transactions'] = len(airtime)
            summary["airtime"] = round(float(airtime.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2) 
            summary['airtime_transactions'] = airtime[['date', 'amount', 'description']].to_dict(orient='records')

            internet_data = debit_transactions[debit_transactions['description'].str.contains(internet_data_keywords)]
            summary['count_of_internet_transactions'] = len(internet_data)
            summary["internet_data"] = round(float(internet_data.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2) 
            summary['internet_data_transactions'] = internet_data[['date', 'amount', 'description']].to_dict(orient='records')

            transportation = debit_transactions[debit_transactions['description'].str.contains(transportation_keywords)]
            summary['count_of_transportation_transactions'] = len(transportation)
            summary["transportation"] = round(float(transportation.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['transportation_transactions'] = transportation[['date', 'amount', 'description']].to_dict(orient='records')

            tv_and_streaming_subscription = debit_transactions[debit_transactions['description'].str.contains(tv_and_streaming_subscription_keywords)]
            summary['count_of_tv_and_streaming_subscription_transactions'] = len(tv_and_streaming_subscription)
            summary["tv_and_streaming_subscription"] = round(float(tv_and_streaming_subscription.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['tv_and_streaming_subscription_transactions'] = tv_and_streaming_subscription[['date', 'amount', 'description']].to_dict(orient='records')


            online_and_web_purchases = debit_transactions[debit_transactions['description'].str.contains(online_and_web_keywords)]
            summary['count_of_online_and_web_purchases_transactions'] = len(tv_and_streaming_subscription)
            summary["online_and_web_purchases"] = round(float(online_and_web_purchases.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['online_and_web_purchases_transactions'] = online_and_web_purchases[['date', 'amount', 'description']].to_dict(orient='records')

            gambling = debit_transactions[debit_transactions['description'].str.contains(gambling_keywords)]
            summary['count_of_gambling_transactions'] = len(gambling)
            summary["gambling"] = round(float(gambling.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['gambling_transactions'] = gambling[['date', 'amount', 'description']].to_dict(orient='records')

            loan_transactions = credit_transactions[credit_transactions['description'].str.contains(loan_or_repayment_keywords)]
            summary['count_of_loan_transactions'] = len(loan_transactions)
            summary["loan"] = round(float(loan_transactions.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['loan_transactions'] = loan_transactions[['date', 'amount', 'description']].to_dict(orient='records')

            loan_repayment_transactions = debit_transactions[debit_transactions['description'].str.contains(loan_or_repayment_keywords)]
            summary['count_of_loan_repayment_transactions'] = len(loan_repayment_transactions)
            summary["loan_repayment"] = round(float(loan_repayment_transactions.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['loan_repayment_transactions'] = loan_repayment_transactions[['date', 'amount', 'description']].to_dict(orient='records')

            health = debit_transactions[debit_transactions['description'].str.contains(health_keywords)]
            summary['count_of_health_transactions'] = len(health)
            summary["health"] = round(float(health.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['health_transactions'] = health[['date', 'amount', 'description']].to_dict(orient='records')

            fitness = debit_transactions[debit_transactions['description'].str.contains(fitness_keywords)]
            summary['count_of_fitness_transactions'] = len(fitness)
            summary["fitness"] = round(float(fitness.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['fitness_transactions'] = fitness[['date', 'amount', 'description']].to_dict(orient='records')

            grocery_and_malls = debit_transactions[debit_transactions['description'].str.contains(grocery_and_malls_keywords)]
            summary['count_of_grocery_and_malls_transactions'] = len(loan_transactions)
            summary["grocery_and_malls"] = round(float(grocery_and_malls.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['grocery_and_malls_transactions'] = grocery_and_malls[['date', 'amount', 'description']].to_dict(orient='records')

            food_and_drinks = debit_transactions[debit_transactions['description'].str.contains(food_and_drinks_keywords)]
            summary['count_of_food_and_drinks_transactions'] = len(food_and_drinks)
            summary["food_and_drinks"] = round(float(food_and_drinks.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['food_and_drinks_transactions'] = food_and_drinks[['date', 'amount', 'description']].to_dict(orient='records')

            waste_and_water = debit_transactions[debit_transactions['description'].str.contains(waste_and_water_keywords)]
            summary['count_of_waste_and_water_transactions'] = len(waste_and_water)
            summary["waste_and_water"] = round(float(waste_and_water.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['waste_and_water_transactions'] = waste_and_water[['date', 'amount', 'description']].to_dict(orient='records')

            bars_lounge_club = debit_transactions[debit_transactions['description'].str.contains(bars_lounge_club_keywords)]
            summary['count_of_bars_lounge_transactions'] = len(bars_lounge_club)
            summary["bars_lounge_club"] = round(float(bars_lounge_club.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['bars_lounge_transactions'] = bars_lounge_club[['date', 'amount', 'description']].to_dict(orient='records')

            electricity = debit_transactions[debit_transactions['description'].str.contains(electricity_keywords)]
            summary['count_of_electricity_transactions'] = len(electricity)
            summary["electricity"] = round(float(electricity.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['elecctricity_transactions'] = electricity[['date', 'amount', 'description']].to_dict(orient='records')

            insurance = debit_transactions[debit_transactions['description'].str.contains(insurance_keywords)]
            summary['count_of_insurance_transactions'] = len(insurance)
            summary["insurance"] = round(float(insurance.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['insurance_transactions'] = insurance[['date', 'amount', 'description']].to_dict(orient='records')

            religious = debit_transactions[debit_transactions['description'].str.contains(insurance_keywords)]
            summary['count_of_religious_transactions'] = len(religious)
            summary["religious"] = round(float(religious.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['religious_transactions'] = religious[['date', 'amount', 'description']].to_dict(orient='records')

            
            total_transactions = round(float(debit_transactions.groupby(pd.Grouper(key='date', freq="M")).sum()["amount"].sum()), 2)
            summary['count_of_total_transactions'] = len(data)
            summary['total_transactions'] = total_transactions

            total_monthly_expenses = round(total_transactions - summary["charges_and_stamp_duty"], 2)
            no_of_transacting_months = compute_number_of_transacting_month(data)
            summary['average_monthly_expenses'] = round(float(total_monthly_expenses / no_of_transacting_months), 2)

            # get self transfers after excluding transaction amount greater than 50
            transfer_transactions_greater_than_50 = data[
                                    data['amount'] > 50]

            self_transfer_transactions = transfer_transactions_greater_than_50[
                                    transfer_transactions_greater_than_50['description'].str.contains(str(account_name))]


            self_transfer_inflow = self_transfer_transactions[self_transfer_transactions['type']=='credit'] 
            self_transfer_outflow = self_transfer_transactions[self_transfer_transactions['type']=='debit'] 

            summary['no_of_self_transfer_inflows'] = len(self_transfer_inflow)
            summary['no_of_self_transfer_outflows'] = len(self_transfer_outflow)

            if self_transfer_inflow.empty:
                summary['self_transfer_inflow_amount'] = 0.0
                summary['count_of_self_inflow_transfer_transactions'] = 0
            else:
                summary['self_transfer_inflow_amount'] = round(float(self_transfer_inflow['amount'].sum()), 2)
                summary['count_of_self_transfer_inflow_transactions'] = len(self_transfer_inflow)

            if self_transfer_outflow.empty:
               summary['self_transfer_outflow_amount'] = 0.0
               summary['count_of_self_transfer_outflow_transactions'] = 0
            else: 
                summary['self_transfer_outflow_amount'] = round(float(self_transfer_outflow['amount'].sum()), 2)
                summary['count_of_self_transfer_outflow_transactions'] = len(self_transfer_outflow)

            summary['self_transfer_inflow_transactions'] = self_transfer_inflow[['date', 'amount']].to_dict(orient='records')
            summary['self_transfer_outflow_transactions'] = self_transfer_outflow[['date', 'amount']].to_dict(orient='records')

            # concacatenate all spend variables
            concat_spend = [atm_withdrawals, pos_spend, charges_and_stamp_duty, savings_and_investments, airtime, internet_data, transportation, tv_and_streaming_subscription,\
                            gambling, health, fitness, grocery_and_malls, food_and_drinks, waste_and_water, bars_lounge_club, electricity, insurance, religious]
            
            df_concat_spend = pd.concat(concat_spend)

            # remove duplicates
            distinct_spend = df_concat_spend.drop_duplicates(subset=['amount', "date", "description"])

            # get total spend after removing duplicates
            total_distinct_spend = distinct_spend['amount'].sum()

            total_spend_on_other_transactions = round(float(total_transactions - total_distinct_spend), 2)
            summary['other_transactions'] = total_spend_on_other_transactions

            # get most frquent debits and credits (top billers and beneficiaries)
            list_stopwords = set(stop_words.get_stop_words("en"))
            most_frequent_transactions = data.copy()
            most_frequent_transactions['description'] = most_frequent_transactions['description'].str.lower()
            most_frequent_transactions['description'] = most_frequent_transactions["description"].replace(
                {"withdrawal": "", "transfer": "", "transaction": "", "reversal": "", "cash": "", "funds\s*": "",
                 "tsf\s+": "", "bank": "", "payref": "", "plc": "", "onepay": "",
                 "trf": "", "nip": "", "pur": "", "pmt": "", "pyt": "", "fee": "", "commission": "", "fip": "",
                 "nibss": "",
                 "first": "", "sterling": "", "stanbic\s+ibtc": "", "access": "", "gt": "", "unity": "", "neft": "",
                 "union": "", "uba": "", "wema": "", "fcmb": "", "zenith": "", "providus": "", "trnf": "",
                 "eco": "", "fidelity": "", "keystone": "", "wdl": "", "wd": "", "trsf": "", "stamp": "", "duty": "",
                 "charge": "", "sms": "", "alert": "", "ref": "", "gw": "", "via": "", "vat": "", "atm":"", "acc":"", 
                 "api":"", "idr":"", "any":"", "account":"", "agg":"", "transaction\s*":"", "loop":"", "eazzy":"", 
                 "trnsf":"", "funds":"", "airtime":"", "safcom":"", "visa":"", "paypal":"", "mps":"", "ltd":"", "bal":"",
                 "wallet":"", "payment":"", "mmoney":"", "mono":"", "technologies":"", "nigeria":"", "resources":"", "united":"", 
                 "word":"", "enterprises":"", "thanks":"", "online":""}, regex=True)

        
            most_frequent_transactions['description'] = most_frequent_transactions['description'].replace(
                {"-": "", "_": "", "!": "", "@": "", "#": "", "$": "", "()": "", "=": "", "{": "", "}": "", "|": "",
                 "%": "", "^": "",
                 ";": "", ":": "", ",": "", "`": "", "~": "", "<": "", ">": "", "/": "", "&": "", "\*": "", "\.": ""},
                regex=True)
            most_frequent_transactions['description'] = most_frequent_transactions['description'].str.replace(r'[0-9]', "")
            most_frequent_transactions['description'] = most_frequent_transactions['description'].str.replace(r"\b\w\b", "")

            most_frequent_debit_transactions = most_frequent_transactions[most_frequent_transactions["type"] == "debit"]
            if len(most_frequent_debit_transactions) == 0:
                summary["most_frequent_debit_transfer"] = None
            else:
                debit_split_df = most_frequent_debit_transactions['description'].str.split('to\s+|between').str[1]
                debit_split_df.fillna('', inplace=True)
                most_occurring_debit = [values[0] for values in
                                        Counter(" ".join(debit_split_df).split()).most_common(1)]
            if len(most_occurring_debit) == 0:
                summary["most_frequent_debit_transfer"] = None
            else:
                # convert the keywords to a dataframe
                most_occurring_debit_df = pd.DataFrame(most_occurring_debit).rename(
                    columns={0: 'most_occurring_debit_transfer'})
                most_occurring_debit_df = most_occurring_debit_df['most_occurring_debit_transfer'].apply(
                    lambda x: " ".join([word for word in x.split() if word not in list_stopwords and len(word)>3]))
                most_occurring_debit_df = pd.DataFrame(most_occurring_debit_df).rename(
                    columns={0: 'most_occurring_debit_transfer'})
                if len(most_occurring_debit_df) == 0:
                    most_occurring_debit_df = None
                else:
                    most_frequent_debit_transfer = most_occurring_debit_df['most_occurring_debit_transfer'].tolist()
                    summary["most_frequent_debit_transfer"] = ' '.join(
                        [str(elem) for elem in most_frequent_debit_transfer])

            # for most frequent credit transactions
            most_fequent_credit_transactions = most_frequent_transactions[most_frequent_transactions["type"] == "credit"]
            if len(most_fequent_credit_transactions) == 0:
                summary['most_frequent_credit_transfer'] = None
            else:
                credit_split_df = most_fequent_credit_transactions['description'].str.split('from\s+|frm|between').str[1]
                credit_split_df.fillna('', inplace=True)
                credit_split_df = credit_split_df.str.split('to\s+').str[1]
                credit_split_df.fillna('', inplace=True)
                most_occurring_credit = [values[0] for values in Counter(" ".join(credit_split_df).split()).most_common(1)]
                if len(most_occurring_credit) == 0:
                    summary["most_frequent_credit_transfer"] = None
                else:
                # convert the keywords to a dataframe
                    most_occurring_credit_df = pd.DataFrame(most_occurring_credit).rename(
                    columns={0: 'most_occurring_credit_transfer'})
                    most_occurring_credit_df = most_occurring_credit_df['most_occurring_credit_transfer'].apply(
                    lambda x: " ".join([word for word in x.split() if word not in list_stopwords and len(word)>3 ]))
                    most_occurring_credit_df = pd.DataFrame(most_occurring_credit_df).rename(
                    columns={0: 'most_occurring_credit_transfer'})

                    if len(most_occurring_credit_df) == 0:
                        most_occurring_credit_df = None
                    else:
                        most_frequent_credit_transfer = most_occurring_credit_df['most_occurring_credit_transfer'].tolist()
                        summary["most_frequent_credit_transfer"] = ' '.join(
                        [str(elem) for elem in most_frequent_credit_transfer])

        
        # calculate salary
        predicted_salary = create_salary_or_other_income_or_recurrent_expense_df(data, salary_variables)

        predicted_salary = predicted_salary[
                                    ~predicted_salary['description'].str.contains(str(account_name))]
        predicted_salary[["amount", "balance"]] = predicted_salary[["amount", "balance"]].astype(float)
        predicted_salary["key"] = "salary"


        if (len(predicted_salary) == 0) or (len(predicted_salary) == 1 and not any([salary_keywords in x for x in predicted_salary['description']])):
                    summary["average_predicted_salary"] = 0.0
        else:
            salary_df = predicted_salary[["date", "description", "amount"]]
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
                for index, row in predicted_salary.iterrows():
                    if row['difference_in_days'] > 16:
                        summary["average_predicted_salary"] = round(float(predicted_salary.groupby(pd.Grouper(key='date', freq="M")).sum().sum()["amount"]) / len(predicted_salary), 2)
                    else:
                        summary["average_predicted_salary"] = round(float(predicted_salary.groupby(pd.Grouper(key='date', freq="M")).sum().sum()["amount"]) / (no_unique_months), 2)
            except:
                summary["average_predicted_salary"] = 0
            # summary["number_of_salary_payments"] = int(len(predicted_salary))

            
            # calculate bonuses and allowances
            predicted_other_income = create_salary_or_other_income_or_recurrent_expense_df(data, other_income_variables)
            # merge salary plus other income. I need to remove scenarios where other income picked what salary picked
            predicted_other_income = pd.concat([predicted_salary, predicted_other_income], axis=0).drop_duplicates(subset=["date", "description"], keep=False)
            predicted_other_income = predicted_other_income[predicted_other_income["key"] != "salary"]
            predicted_other_income["key"] = "other_income"
            predicted_other_income[["amount", "balance"]] = predicted_other_income[["amount", "balance"]].astype(float)
            predicted_other_income['date'] = pd.to_datetime(predicted_other_income['date'])
            

            if len(predicted_other_income) == 0 :
                summary['bonuses_and_allowances_transactions'] = []
            else:
                other_income_df =  predicted_other_income[["date", "description", "amount"]]
                other_income_df['date'] = pd.to_datetime(other_income_df['date'])
                other_income_df["year"] = pd.to_datetime(other_income_df["date"]).dt.year
                other_income_df["year"] = other_income_df["year"].apply(lambda x: str(x))
                other_income_df['month_name'] = other_income_df['date'].dt.month_name()

                cats = ['January', 'February', 'March', 'April','May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
                # sort month name
                other_income_df['month-name'] = pd.Categorical(other_income_df['month_name'],categories=cats, ordered=True)
                other_income_df = other_income_df.sort_values(["year", "month-name"])
                other_income_df = other_income_df[['year', 'month-name', 'amount', 'description']]
                other_income_df = other_income_df.to_dict(orient='records')
                summary['bonuses_and_allowances_transactions'] = other_income_df

            return summary

    output = pfm_variables(data, salary_variables=salary_variables, other_income_variables=other_income_variables)

    output = {"status": "success", "output": output}

    return output

if __name__ == "__main__":
    print("starting pfm flask app")
    app.debug = True
    app.run()
