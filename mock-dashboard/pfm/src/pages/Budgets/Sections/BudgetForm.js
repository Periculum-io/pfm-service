import React, { useEffect, useState } from "react";
import './BudgetForm.css';
import { PostDataStatus } from "../../../library/Variables";
import Utils from "../../../library/Utils";
import { useForm } from "react-hook-form";
import { BudgetCategories, Currency } from "../../../library/Data";
import CustomCategoryFieldset from "./CustomCategoryFieldset";

function BudgetForm(props) {
  let content = null;

  const data = !Utils.isFieldEmpty(props.data) ? props.data : [];

  const defaultValues = {
    totalBudgetCalculated: !Utils.isFieldEmpty(data) ? data.monthlyBudgetSet : 0,
    startDate: !Utils.isFieldEmpty(data) ? data.startDate : null,
    endDate: !Utils.isFieldEmpty(data) ? data.endDate : null,
    customCategories: []
  }
  const { register, watch, control, formState: { errors }, handleSubmit, reset } = useForm({ defaultValues });
  const watchTotalBudgetCalculated = watch("totalBudgetCalculated", false);
  const [formState, setFormState] = useState(PostDataStatus.INITIAL);
  const [amountRemaining, setAmountRemaining] = useState(watchTotalBudgetCalculated);
  const [values, setValues] = useState({});

  if(!Utils.isFieldEmpty(data) && !Utils.isFieldEmpty(data.categories)) {
    data.categories.forEach(element => {
      defaultValues[element.field] = element.budgetSet;
    });
  }

  const sumValues = (obj) => {
    return Object.values(obj).reduce((a, b) => a + b, 0);
  }

  const resetForm = () => {
    reset();
  }
  
  const onSubmit = (formData) => {
    console.log(formData)
    props.parentCallback();
  }

  const handleInputChange = (target, name) => {
    let value = 0;

    if(Number.isNaN(target) === false && !Utils.isFieldEmpty(target)) {
      value = target;
    }

    if(values[name] !== value) {
      setValues(prevState => ({
        ...prevState,
        [name]: value
      }));
    }
  }

  useEffect(() => {
    let totalSpent = 0;
    let array = {};

    if(!Utils.isFieldEmpty(data) && !Utils.isFieldEmpty(data.categories) && Utils.isFieldEmpty(values)) {
      data.categories.forEach(element => {
        array[element.field] = element.budgetSet;
      });

      setValues(array);
    }

    if(!Utils.isFieldEmpty(values)) {
      totalSpent = sumValues(values);
    }

    setAmountRemaining(watchTotalBudgetCalculated - totalSpent);
  }, [watchTotalBudgetCalculated, values, data])
  
  if(formState === PostDataStatus.INITIAL) {
    content = <>
      <div className="header-row">
        <h2 className='detail-header'>{ !Utils.isFieldEmpty(data.categories) ? "Edit Budget" : "Create New Budget" }</h2>
      </div>
      <form className="budget-form" onSubmit={handleSubmit(onSubmit)}>
        <div className='input-with-label-container'>
          <label className="text-dark text-medium-bold">Total Budget Calculated</label>
          <div className="input-container">
            <span>{Utils.displayCurrencySymbol(Currency.format, Currency.symbol)}</span>
            <input type={'text'} {...register("totalBudgetCalculated", 
              { 
                required: "Total Budget Calculated must not be empty",
                pattern: {
                  value: /^[0-9]*$/,
                  message: "Total calculated budget must be a number"
                } 
              })} />
          </div>
          <span className="text-error">{errors.totalBudgetCalculated?.message}</span>
        </div>
        <p className="text-dark">Budget amount left: <span className="text-success text-medium-bold">
          {Utils.formatCurrency(Currency.format, Currency.symbol, amountRemaining)}</span>
        </p>
        <hr />
        <div className="header-row">
          <h2 className='detail-header'>Categories</h2>
        </div>
        <div className="budget-form-categories-container">
          {!Utils.isFieldEmpty(BudgetCategories) && 
            BudgetCategories.map((category, i) => {
              return <div className='input-with-label-container' key={i}>
                <label className="text-dark text-medium-bold">{category.label}</label>
                <div className="input-container">
                  <span>{Utils.displayCurrencySymbol(Currency.format, Currency.symbol)}</span>
                  <input type={'text'} defaultValue={defaultValues[category.field]} {...register(category.field,
                    { 
                      onChange: (e) => { handleInputChange(parseFloat(e.target.value), category.field) },
                      pattern: {
                        value: /^[0-9]*$/,
                        message: category.label + " must be a number"
                      } 
                    },)} />
                </div>
                <span className="text-error">{errors[category.field]?.message}</span>
              </div>
            })
          }
        </div>
        <CustomCategoryFieldset {...{ control, register, defaultValues, errors }} />
        <div className="header-row">
          <h2 className='detail-header'>Set Timeline</h2>
        </div>
        <div className="budget-form-timeline-container">
          <div className='input-with-label-container'>
            <label className="text-dark text-medium-bold">Start date</label>
            <input type={'date'} {...register("startDate", 
              { 
                required: "Start date is required", 
              })} />
            <span className="text-error">{errors.startDate?.message}</span>
          </div>
          <div className='input-with-label-container'>
            <label className="text-dark text-medium-bold">End date</label>
            <input type={'date'} {...register("endDate", 
              { 
                required: "End date is required"
              })} />
            <span className="text-error">{errors.endDate?.message}</span>
          </div>
        </div>
        <div className="budget-form-button-container">
          <button type="submit" className="button-square button-solid budget-form-submit-button">{props.buttonLabel}</button>
        </div>
      </form>
    </>    
  } else if(formState === PostDataStatus.FETCHING) {
    
  } else if(formState === PostDataStatus.SUCCESS) {
    
  } else if(formState === PostDataStatus.FAILURE) {
    
  }

  return (
    <div className="budget-form-body">
      {content}
    </div>
  )
}

export default BudgetForm;