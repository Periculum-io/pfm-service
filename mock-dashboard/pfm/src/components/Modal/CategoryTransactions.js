import React, { useMemo } from "react";
import { BudgetCategoriesTransactions, Currency } from "../../library/Data";
import Utils from "../../library/Utils";
import CategoryCard from "../../pages/Budgets/Sections/CategoryCard";
import { Table } from "../Table/Table";
import "./Modal.css";

function CategoryTransactions(props) {
  const category = props.category;

  const theadersTransactions = useMemo(() => [
    { 
      id: 'icon',
      Cell: data => {
        return (
          <img className="category-transaction-icon" src={`${process.env.PUBLIC_URL}/assets/icons/arrow-down-solid-red.svg`}  alt="" />
        );
      },
      disableSortBy: true,
    },
    { 
      id: 'name',
      Cell: data => {
        return (
          <div className="transactions-name-col">
            <p className="text-medium-bold text-dark">{(data.row.original.name).toUpperCase()}</p>
            <p className="text-dark">{data.row.original.status}</p>
          </div>
        );
      },
      disableSortBy: true,
    },
    { 
      id: 'amount',
      Cell: data => {
        return (
          <div className="transactions-amount-col">
            <p className="text-dark text-medium-bold">{Utils.formatCurrency(Currency.format, Currency.symbol, data.row.original.amount)}</p>
            <p className="text-dark">{Utils.formatLongDate(data.row.original.date)}</p>
          </div>
        );
      },
      disableSortBy: true,
    }]
  )

  return (
    <div className="modal-dialog category-transactions-dialog">
      <div className="header-row-single-right">
        <img src={`${process.env.PUBLIC_URL}/assets/icons/close-square.svg`}  alt="Close" onClick={props.close} />
      </div>
      <CategoryCard category={category} />
      <h3 className="text-medium-bold text-dark">Transactions</h3>
      <div className="category-transactions-table-container scrollbar">
        <Table data={BudgetCategoriesTransactions} columns={theadersTransactions} showHeader={false} />
      </div>
    </div>
  )
}

export default CategoryTransactions;