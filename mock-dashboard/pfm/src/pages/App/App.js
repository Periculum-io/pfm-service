import './App.css';
import SideBar from "../../components/SideBar/SideBar";
import Home from"../Home/Home";
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Budgets from '../Budgets/Budgets';
import Financial from '../Financial/Financial';

function App() {
  return (
    <Router basename='/pfm-service'>
      <Routes>
        <Route path="/" element={
          <div className="parent-body">
            <SideBar />
            <div className="main-body" >
              <Home />
            </div>
          </div>
        } />
        <Route path="/budgets" element={
          <div className="parent-body">
            <SideBar />
            <div className="main-body" >
              <Budgets />
            </div>
          </div>
        } />
        <Route path="/financial" element={
          <div className="parent-body">
            <SideBar />
            <div className="main-body" >
              <Financial />
            </div>
          </div>
        } />
      </Routes>
    </Router>
  );
}

export default App;