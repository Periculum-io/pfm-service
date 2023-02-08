import React, { useState } from "react";
import { Currency } from "../../library/Data";
import { AddFinancialGoalViews } from "../../library/Variables";
import Utils from "../../library/Utils";
import "./Modal.css";
import { useForm } from "react-hook-form";

function AddFinancialGoal(props) {
  let content = null;

  const [view, setView] = useState(AddFinancialGoalViews.INITIAL);
  const { register, watch, formState: { errors }, handleSubmit,  reset } = useForm();
  const { 
    register: registerSavings,
    formState: { errors: errorsSavings },
    handleSubmit: handleSubmitSavings } = useForm();
  const watchSetReminder = watch("setReminder", false);

  const backButton = <button className="button-back" onClick={() => setView(AddFinancialGoalViews.INITIAL)}>
    <img src="/assets/icons/arrow-left.svg" alt="" />
    Back
  </button>

  const onSubmit = (formData) => {
    console.log(formData)
  }

  const onSubmitSavings = (formData) => {
    console.log(formData)
  }

  if(view === AddFinancialGoalViews.INITIAL) {
    content = <>
      <div className="header-row">
        <h2 className="text-medium-bold text-light">Build wealth and discipline</h2>
        <img src="/assets/icons/close-square.svg" alt="Close" onClick={props.close} />
      </div>
      <div>
        <h4>What's your goal?</h4>
        <div className="goals-container scrollbar">
          <div className="goal" onClick={() => setView(AddFinancialGoalViews.TARGET)}>
            <h2 className="text-detail">Target Savings</h2>
            <p className="text-darker">Own a home, Buy a new gadget, etc.</p>
          </div>
          <div className="goal" onClick={() => setView(AddFinancialGoalViews.DEBT)}>
            <h2 className="text-detail">Debt Repayment</h2>
            <p className="text-darker">Set a goal to pay back a debt</p>
          </div>
          <div className="goal" onClick={() => setView(AddFinancialGoalViews.EMERGENCY)}>
            <h2 className="text-detail">Emergency Funds</h2>
            <p className="text-darker">Build an emergency fund</p>
          </div>
        </div>
      </div>
    </>
  } else if(view === AddFinancialGoalViews.TARGET) {
    content = <>
      {backButton}
      <div className="header-row">
        <h2 className="text-medium-bold text-detail">Target savings</h2>
        <img src="/assets/icons/close-square.svg" alt="Close" onClick={props.close} />
      </div>
      <form className="target-form scrollbar" onSubmit={handleSubmit(onSubmit)}>
        <div className='input-with-label-container goal-name'>
          <label className="text-dark text-medium-bold">Name your goal</label>
          <input type={'text'} placeholder="Enter name" {...register("goalName", 
            { 
              required: "Goal name cannot be empty"
            })} />
          <span className="text-error">{errors.goalName?.message}</span>
        </div>
        <div className='input-with-label-container'>
          <label className="text-dark text-medium-bold">Target amount</label>
          <div className="input-container">
            <span>{Utils.displayCurrencySymbol(Currency.format, Currency.symbol)}</span>
            <input type={'text'} {...register("targetAmount", 
              { 
                required: "Target amount cannot be empty",
                pattern: {
                  value: /^[0-9]*$/,
                  message: "Target amount must be a number"
                } 
              })} />
          </div>
          <span className="text-error">{errors.targetAmount?.message}</span>
        </div>
        <div>
          <label className="text-dark text-medium-bold">Set timeline</label>
          <div className="target-form-timeline-container">
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
        </div>
        <div className="target-form-reminder-container">
          <label className="text-dark text-medium-bold">Set reminder</label>
          <label className="switch">
            <input type="checkbox" {...register("setReminder")} />
            <span className="slider round"></span>
          </label>
        </div>
        {watchSetReminder === true &&
          <div className='input-with-label-container goal-name'>
            <label className="text-dark text-medium-bold">Reminder</label>
            <div className="target-form-reminder-fields-container">
              <input type={'text'} defaultValue={1} {...register("reminderNumber", 
                { 
                  required: "Reminder cannot be empty",
                  pattern: {
                    value: /^[0-9]*$/,
                    message: "Must be a number"
                  }
                })} />
              <select {...register("reminderTimeline")}>
                <option value="day">day(s)</option>
                <option value="week">week(s)</option>
                <option value="month">month(s)</option>
              </select>
            </div>
          </div>
        }
        <div className="target-form-button-container">
          <button type="submit" className="button-square button-solid">Create goal</button>
        </div>
      </form>
    </>
  } else if(view === AddFinancialGoalViews.EMERGENCY) {
    content = <>
      {backButton}
      <div className="header-row">
        <h2 className="text-medium-bold text-detail">Target savings</h2>
        <img src="/assets/icons/close-square.svg" alt="Close" onClick={props.close} />
      </div>
      <form className="target-form scrollbar" onSubmit={handleSubmitSavings(onSubmitSavings)}>
        <div className='input-with-label-container'>
          <label className="text-dark text-medium-bold">Target amount</label>
          <div className="input-container">
            <span>{Utils.displayCurrencySymbol(Currency.format, Currency.symbol)}</span>
            <input type={'text'} {...registerSavings("targetAmount", 
              { 
                required: "Target amount cannot be empty",
                pattern: {
                  value: /^[0-9]*$/,
                  message: "Target amount must be a number"
                } 
              })} />
          </div>
          <span className="text-error">{errorsSavings.targetAmount?.message}</span>
        </div>
        <div>
          <label className="text-dark text-medium-bold">Set timeline</label>
          <div className="target-form-timeline-container">
            <div className='input-with-label-container'>
              <label className="text-dark text-medium-bold">Start date</label>
              <input type={'date'} {...registerSavings("startDate", 
                { 
                  required: "Start date is required", 
                })} />
              <span className="text-error">{errorsSavings.startDate?.message}</span>
            </div>
            <div className='input-with-label-container'>
              <label className="text-dark text-medium-bold">End date</label>
              <input type={'date'} {...registerSavings("endDate", 
                { 
                  required: "End date is required"
                })} />
              <span className="text-error">{errorsSavings.endDate?.message}</span>
            </div>
          </div>
        </div>
        <div className="target-form-button-container">
          <button type="submit" className="button-square button-solid">Create fund</button>
        </div>
      </form>     
    </>
  } else if(view === AddFinancialGoalViews.DEBT) {
    content = <>
      {backButton}
      <div className="header-row">
        <h2 className="text-medium-bold text-detail">Debt repayment</h2>
        <img src="/assets/icons/close-square.svg" alt="Close" onClick={props.close} />
      </div>
      <form className="target-form scrollbar" onSubmit={handleSubmitSavings(onSubmitSavings)}>
        <div className='input-with-label-container'>
          <label className="text-dark text-medium-bold">Target amount</label>
          <div className="input-container">
            <span>{Utils.displayCurrencySymbol(Currency.format, Currency.symbol)}</span>
            <input type={'text'} {...registerSavings("targetAmount", 
              { 
                required: "Target amount cannot be empty",
                pattern: {
                  value: /^[0-9]*$/,
                  message: "Target amount must be a number"
                } 
              })} />
          </div>
          <span className="text-error">{errorsSavings.targetAmount?.message}</span>
        </div>
        <div>
          <label className="text-dark text-medium-bold">Set timeline</label>
          <div className="target-form-timeline-container">
            <div className='input-with-label-container'>
              <label className="text-dark text-medium-bold">Start date</label>
              <input type={'date'} {...registerSavings("startDate", 
                { 
                  required: "Start date is required", 
                })} />
              <span className="text-error">{errorsSavings.startDate?.message}</span>
            </div>
            <div className='input-with-label-container'>
              <label className="text-dark text-medium-bold">End date</label>
              <input type={'date'} {...registerSavings("endDate", 
                { 
                  required: "End date is required"
                })} />
              <span className="text-error">{errorsSavings.endDate?.message}</span>
            </div>
          </div>
        </div>
        <div className="target-form-button-container">
          <button type="submit" className="button-square button-solid">Create repayment</button>
        </div>
      </form>  
    </>
  }

  return (
    <div className="modal-dialog add-goal-dialog">
      {content}
    </div>
  )
}

export default AddFinancialGoal;