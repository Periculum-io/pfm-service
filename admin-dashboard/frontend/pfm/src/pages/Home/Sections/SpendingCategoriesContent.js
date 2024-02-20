import React, { useCallback, useMemo, useState } from "react";
import Dropdown from "../../../components/Dropdown/Dropdown";
import List from "../../../components/List/List";
import { Table } from "../../../components/Table/Table";
import { Currency, SpendingCategoriesAll } from "../../../library/Data";
import Utils from "../../../library/Utils";
import { SpendingCategoriesSelector } from "../../../library/Variables";
import "./SpendingCategoriesContent.css";

function SpendingCategoriesContent(props) {
  const dropdownOptions = props.dropdownOptions;
  const [selector, setSelector] = useState(SpendingCategoriesSelector.SEVEN);
  const theadersCategories = useMemo(() => [
    { 
      Header: 'Icon',
      accessor: 'iconLink',
      Cell: data => {
        return (
          <div className="category-icon"><img src={data.row.original.iconLink} alt="" /></div>
        );
      },
      disableSortBy: true,
    },
    { 
      Header: 'Name',
      id: 'name',
      Cell: data => {
        return (
          <div className="subscription-name-col">
            <p className="text-medium-bold">{data.row.original.label}</p>
            <p className="text-darker">{(data.row.original.transactions).length} transaction(s)</p>
          </div>
        );
      },
      disableSortBy: true,
    },
    { 
      Header: 'Amount',
      accessor: 'amount',
      Cell: data => {
        return (
          <p className="text-dark text-medium-bold">{Utils.formatCurrency(Currency.format, Currency.symbol, data.row.original.amount)}</p>
        );
      },
      disableSortBy: true,
    },
    {
      // Build our expander column
      id: "expander", // Make sure it has an ID
      Header: ({ getToggleAllRowsExpandedProps, isAllRowsExpanded }) => (
        <span {...getToggleAllRowsExpandedProps()}>
          {isAllRowsExpanded 
            ? <img src="/assets/icons/arrow-down-outline.svg" alt="" /> 
            : <img src="/assets/icons/arrow-right-outline.svg" alt="" />}
        </span>
      ),
      Cell: ({ row }) => (
        <span {...row.getToggleRowExpandedProps()}>
          {row.isExpanded 
            ? <img src="/assets/icons/arrow-down-outline.svg" alt="" /> 
            : <img src="/assets/icons/arrow-right-outline.svg" alt="" />}
        </span>
      )
    }]
  )

  const renderRowSubComponent = useCallback(
    ({ row }) => {
      let listData = [];
      row.original.transactions.forEach(transaction => {
        listData.push({
          header: <>
            <span className="text-medium-bold">{transaction.name}</span>
            <span className="text-light">{Utils.formatLongDate(transaction.date)}</span>
          </>,
          detail: Utils.formatCurrency(Currency.format, Currency.symbol, transaction.total)
        })
      });

      return <List listClass="list-col" listItemClass="list-item-row" listDetailClass="" listContent={listData}
        headerClass={"list-header-light list-header-col-container"} />
    },
    []
  );

  const handleDropdownDateCallback = (date, value, param) => {
    setSelector(value);
  }

  const isActiveCategory = (target) => {
    if(target === selector) {
      return "active-category"
    }
  }

  return (
    <div className="spending-categories-table-container">
      <div className="header-row">
        <h2 className="text-dark">Spending Categories</h2>
        <div className="spending-categories-container">
          <button className={isActiveCategory(SpendingCategoriesSelector.SEVEN)} 
            onClick={() => setSelector(SpendingCategoriesSelector.SEVEN)}>Last 7 Days</button>
          <button className={isActiveCategory(SpendingCategoriesSelector.THIRTY)} 
            onClick={() => setSelector(SpendingCategoriesSelector.THIRTY)}>Last 30 Days</button>
          <button className={isActiveCategory(SpendingCategoriesSelector.YEAR)} 
            onClick={() => setSelector(SpendingCategoriesSelector.YEAR)}>This Year</button>
          <Dropdown options={dropdownOptions} selectClass={isActiveCategory(SpendingCategoriesSelector.CUSTOM)}
            parentDateCallBack={(date, value, param) => handleDropdownDateCallback(date, value, param)} />
        </div>
      </div>
      <Table tableClass="statement-type-table" pageSize={[10]} data={SpendingCategoriesAll[selector]} pagination={true}
        columns={theadersCategories} showHeader={false} renderRowSubComponent={renderRowSubComponent} />
    </div>
  )
}

export default SpendingCategoriesContent;