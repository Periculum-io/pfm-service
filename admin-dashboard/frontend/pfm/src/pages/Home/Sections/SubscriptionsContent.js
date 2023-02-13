import React, { useMemo } from "react";
import { Table } from "../../../components/Table/Table";
import { Currency } from "../../../library/Data";
import Utils from "../../../library/Utils";
import "./SubscriptionsContent.css";

function SubscriptionsContent(props) {
  const data = props.data;

  const theadersSubscriptions = useMemo(() => [
    { 
      Header: 'Icon',
      accessor: 'iconLink',
      Cell: data => {
        return (
          <img className="subscription-icon" src={data.row.original.iconLink} alt={data.row.original.name + " icon"} />
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
            <p className="text-medium-bold">{data.row.original.name}</p>
            <p className="text-darker">{Utils.formatLongDate(data.row.original.date)}</p>
          </div>
        );
      },
      disableSortBy: true,
    },
    { 
      Header: 'Category',
      accessor: 'category',
      Cell: data => {
        return (
          <div className="subscription-category-row">
            <span className="category-bullet-point" style={{ backgroundColor: data.row.original.categoryColor }}></span>
            <p>{data.row.original.category}</p>
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
    }]
  )

  return (
    <div className={"subscription-container " + props.class}>
      <div className="header-row">
        <h2 className="text-dark">{props.title}</h2>
        {!Utils.isFieldEmpty(props.parentCallback) &&
          <button className="button-link-lighter button-link-bold button-text-large" 
          onClick={() => props.parentCallback()}>See all</button>
        }
      </div>
      <Table tableClass="statement-type-table" pageSize={[50]} data={data} columns={theadersSubscriptions} showHeader={false} />
    </div>
  )
}

export default SubscriptionsContent;