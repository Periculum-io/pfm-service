import React from "react";
import Utils from "../../library/Utils";
import "./List.css";

function List(props) {
  const listContent = props.listContent;

  const listItems = !Utils.isFieldEmpty(listContent) && listContent.map((item, i) => {
    return <li key={i} className={props.listItemClass}>
      {typeof item === 'object' 
        ? <>
            <h2 className={props.headerClass}>
              {!Utils.isFieldEmpty(item.legendColor) && <span className="list-legend" style={{ background: item.legendColor }}></span>}
              {item.header}
            </h2>
            <p className={props.listDetailClass}>{item.detail}</p>
          </>
        : item
      }</li>
  })

  return (
    <ul className={props.listClass}>{listItems}</ul>
  )
}

export default List;