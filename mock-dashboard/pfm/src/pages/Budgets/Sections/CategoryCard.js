import React, { useEffect, useRef, useState } from "react";
import Bar from "../../../components/Bar/Bar";
import List from "../../../components/List/List";
import { Currency } from "../../../library/Data";
import Utils from "../../../library/Utils";
import "./CategoryCard.css";

function CategoryCard(props) {
  let exceededOrReached = "reached";

  const category = props.category;
  const isBudgetMet = category.amountSpent >= category.budgetSet ? true : false;
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const ref = useRef(null);

  if(category.amountSpent > category.budgetSet) {
    exceededOrReached = "exceeded";
  }

  const menuContainer = !Utils.isFieldEmpty(props.parentCallback)
    ? <div className="category-card-menu-container" ref={ref}>
        <img src="/assets/icons/menu.svg" alt="" onClick={() => setIsMenuOpen(!isMenuOpen)} />
        {isMenuOpen &&
          <div className="category-card-menu" onClick={() => props.parentCallback(category)}>
            View Transactions
          </div>
        }
      </div>
    : null;

  const budgetExceededContent = isBudgetMet === true 
    ? <div className="budget-exceeded-container">
        <img src="/assets/icons/danger.svg" alt="" />
        <p>Budget limit {exceededOrReached}</p>
      </div>
    : null;

  useEffect(() => {
    function handleClickOutside(event) {
      if (ref.current && !ref.current.contains(event.target)) {
        setIsMenuOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
  }, [ref])

  return (
    <div className="category-card-body">
      <div className="header-row">
        <h3 className="text-dark">{category.name}</h3>
        {menuContainer}
      </div>
      <Bar values={{ amount: category.amountSpent, total: category.budgetSet }} color={ category.color } />
      <div>
        <List listClass="list-row" listItemClass="list-item-col" headerClass={"text-medium list-header-small list-header-light list-header-row"}
          listDetailClass="text-dark list-detail-big list-detail-bold" listContent={[
            {
              header: 'Amount Spent',
              detail: Utils.formatCurrency(Currency.format, Currency.symbol, category.amountSpent)
            },
            {
              header: 'Budget Set',
              detail: Utils.formatCurrency(Currency.format, Currency.symbol, category.budgetSet)
            }
          ]} />
      </div>
      {budgetExceededContent}
    </div>
  )
}

export default CategoryCard;