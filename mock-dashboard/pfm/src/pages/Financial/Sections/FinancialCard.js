import React, { useEffect, useRef, useState } from "react";
import Bar from "../../../components/Bar/Bar";
import List from "../../../components/List/List";
import { Currency } from "../../../library/Data";
import Utils from "../../../library/Utils";
import "./FinancialCard.css";

function FinancialCard(props) {
  let content = null;

  const data = props.data;
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const ref = useRef(null);

  const menuContainer = !Utils.isFieldEmpty(props.parentCallback)
    ? <div className="financial-card-menu-container" ref={ref}>
        <img src="/assets/icons/menu.svg" alt="" onClick={() => setIsMenuOpen(!isMenuOpen)} />
        {isMenuOpen &&
          <div className="financial-card-menu" onClick={() => handleMenuClick()}>
            View Transactions
          </div>
        }
      </div>
    : null;

  const handleMenuClick = () => {
    setIsMenuOpen(false);
    props.parentCallback(data);
  }

  if(props.type === "nested-bar") {
    content = <>
      <div className="header-row">
        <div>
          <p className="text-light">{data.name}</p>
          <h2 className="text-dark">{Utils.formatCurrency(Currency.format, Currency.symbol, data.spent)}</h2>
        </div>
        {menuContainer}
      </div>
      <div className="financial-card-emergency-funds-container">
        <div className="financial-card-emergency-weekly-container">
          <p className="text-light">Savings amount:</p>
          <h3 className="text-dark">{Utils.formatCurrency(Currency.format, Currency.symbol, 20000)} <span className="text-light">
            weekly</span></h3>
        </div>
        <div className="financial-card-nested-bar-container">
          <p>20% achieved of 250k</p>
          <Bar values={{ amount: data.spent, total: data.total }} color={ data.color } />
        </div>
      </div>
    </>
  } else {
    let savings = data.total - data.spent;

    content = <>
      <div className="header-row">
        <h3 className="text-dark">{data.name}</h3>
        {menuContainer}
      </div>
      <div className="financial-card-savings-container">
        <p className="text-light">Amount Saved</p>
        <h2 className="text-dark">{Utils.formatCurrency(Currency.format, Currency.symbol, savings)}</h2>
      </div>
      <div className="financial-card-single-bar-container">
        <Bar values={{ amount: data.spent, total: data.total }} color={ data.color } />
      </div>
      <div>
        <p className="text-light">80% of 500k target achieved</p>
      </div>
    </>
  }

  useEffect(() => {
    function handleClickOutside(event) {
      if (ref.current && !ref.current.contains(event.target)) {
        setIsMenuOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
  }, [ref])

  return (
    <div className="financial-card-body">
      {content}
    </div>
  )
}

export default FinancialCard;