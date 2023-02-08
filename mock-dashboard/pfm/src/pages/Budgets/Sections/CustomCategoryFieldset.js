import React from "react";
import { useFieldArray } from "react-hook-form";
import { Currency } from "../../../library/Data";
import Utils from "../../../library/Utils";

function CustomCategoryFieldset({ control, register }) {
  const { fields, append, remove } = useFieldArray({
    control,
    name: "customCategories"
  });

  return (
    <div className="budget-form-custom-category-container">
      <div className="budget-form-button-container">
        <button type="button" className="button-link text-medium-bold" onClick={() => append()}>
          + Add a custom category</button>
      </div>
      {fields.map((item, i) => {
        return <fieldset key={item.id + "-" + i}>
          <div className="budget-form-custom-category-inputs-container">
            <div className='input-with-label-container'>
              <label className="text-dark text-medium-bold">Category Name</label>
              <input type={'text'} {...register(`customCategories.${i}.categoryName`, 
                { 
                  required: "Category name is required"
                })} />
            </div>
            <div className='input-with-label-container'>
              <label className="text-dark text-medium-bold">Budget Amount</label>
              <div className="input-container">
                <span>{Utils.displayCurrencySymbol(Currency.format, Currency.symbol)}</span>
                <input type={'text'} {...register(`customCategories.${i}.budgetAmount`, 
                  { 
                    required: "Budget amount is required",
                    pattern: {
                      value: /^[0-9]*$/,
                      message: "Budget amount must be a number"
                    }
                  })} />
              </div>
            </div>
          </div>
          <div className="budget-form-button-container">
            <button type="button" onClick={() => remove(i)} className="button-square button-solid">
              Remove Field
            </button>
          </div>
        </fieldset>
      })}
    </div>
  );
}

export default CustomCategoryFieldset;