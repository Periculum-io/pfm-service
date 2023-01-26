CREATE SCHEMA IF NOT EXISTS PdfProcessing;
CREATE TABLE IF NOT EXISTS PdfProcessing.Region
(
    key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_name TEXT NOT NULL,
    currency VARCHAR(128) NOT NULL,
    currency_format VARCHAR(100) NOT NULL,
    country_symbol VARCHAR(10) NOT NULL,
    status BOOLEAN NOT NULL,
    created TIMESTAMP(3) WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS PdfProcessing.Customer(
  key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_name VARCHAR(128) NOT NULL,
  api_key VARCHAR(128) NOT NULL,  
  region_key INT REFERENCES PdfProcessing.Region(key) NOT NULL,
  is_active BIT NOT NULL,
  created_date TIMESTAMP(3) WITH TIME ZONE NOT NULL  
);

CREATE TABLE IF NOT EXISTS PdfProcessing.FileStatus
(
    key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    job_id VARCHAR(32) NOT NULL,
    customer_key INT REFERENCES PdfProcessing.Customer(key) NOT NULL,
    file_name VARCHAR(128) NOT NULL,
    file_password VARCHAR(128),
    processing_status VARCHAR(30) NOT NULL,
    processing_start_date TIMESTAMP(3) WITH TIME ZONE NOT NULL,
    processing_end_date TIMESTAMP(3) WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS PdfProcessing.Plan (
  key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_key INT REFERENCES PdfProcessing.Customer(key),
  plan_type TEXT NOT NULL,
  description TEXT NOT NULL,
  base_price NUMERIC(20, 2) NOT NULL,  
  is_active BIT NOT NULL,
  created_date TIMESTAMP(3) WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS PdfProcessing.PlanTier (
  key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  plan_key INT REFERENCES PdfProcessing.Plan(key) NOT NULL,
  tier_name TEXT NOT NULL,
  discount NUMERIC(18, 2) NOT NULL,
  min_calls INT NOT NULL,
  max_calls INT NOT NULL,
  description TEXT NOT NULL,
  is_active bit NOT NULL,
  created_date TIMESTAMP(3) WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS PdfProcessing.CustomerBalance(
  key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_key INT REFERENCES PdfProcessing.Customer(key) NOT NULL,
  balance NUMERIC(20,2),
  updated_date TIMESTAMP(3) WITH TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS PdfProcessing.CustomerBalanceHistory(
  key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_key INT REFERENCES PdfProcessing.Customer(key) NOT NULL,
  file_status_key INT REFERENCES PdfProcessing.FileStatus(key),
  old_balance NUMERIC(20, 2) NOT NULL,
  new_balance NUMERIC(20, 2) NOT NULL,
  type TEXT NOT NULL,
  description TEXT NOT NULL,
  date TIMESTAMP(3) WITH TIME ZONE NOT NULL
);