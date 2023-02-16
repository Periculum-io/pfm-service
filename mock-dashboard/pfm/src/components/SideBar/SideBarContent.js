import React from "react";
import { Link, NavLink } from "react-router-dom";

function SideBarContent() {
  return (
    <>
      <div className="logo-container">
        <Link to='/' className="logo-link" >
          <img src="/assets/logo/insights-full.svg" alt="Insights" className="insights-logo" />
        </Link>
      </div>
      <div className="sidebar-links">
        <NavLink exact to={"/"} className={"sidebar-link-row"}>
          <img src="/assets/icons/home-hashtag.svg" alt="" />
          <p>Categories</p>
        </NavLink>
        {/* <NavLink exact to={"/budgets"} className="sidebar-link-row">
          <img src="/assets/icons/graph.svg" alt="" />
          <p>Budgets</p>
        </NavLink>
        <NavLink exact to={"/financial"} className="sidebar-link-row">
          <img src="/assets/icons/card.svg" alt="" />
          <p>Finance Goals</p>
        </NavLink> */}
      </div>
      <Link to={"/"} className="sidebar-link-logout sidebar-link-row">
        <img src="/assets/icons/logout.svg" alt="" />
        <p>Log out</p>
      </Link>
    </>
  )
}

export default SideBarContent;