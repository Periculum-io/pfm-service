import pandas as pd
import warnings

warnings.filterwarnings("ignore")


def preprocessing_layer(json_data):
    preprocessed_df = pd.DataFrame(json_data)
    preprocessed_df["nuban"] = [1] * len(preprocessed_df)
    preprocessed_df["type"] = preprocessed_df["type"].str.lower()
    preprocessed_df["amount"] = pd.to_numeric(preprocessed_df["amount"])
    preprocessed_df["description"] = preprocessed_df["description"].str.lower()
    preprocessed_df["date"] = pd.to_datetime(preprocessed_df["date"], errors='coerce')
    preprocessed_df["balance"] = pd.to_numeric(preprocessed_df["balance"])
    if 'transactionStatus' in preprocessed_df.columns:
        preprocessed_df['transactionStatus'] = preprocessed_df["transactionStatus"].str.lower()
        preprocessed_df = preprocessed_df[["nuban", "date", "amount", "type", "description", "balance", "transactionStatus"]]
    else:
        preprocessed_df = preprocessed_df[["nuban", "date", "amount", "type", "description", "balance"]]

    if len(preprocessed_df) != 0:
        preprocessed_df = preprocessed_df.sort_values(by="date").reset_index().drop("index", axis=1)

    return preprocessed_df
