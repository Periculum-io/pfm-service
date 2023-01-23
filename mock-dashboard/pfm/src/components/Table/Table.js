import React, { useState, useMemo, useEffect, useRef } from 'react';
import * as matchSorter from 'match-sorter';
import './Table.css';
import { 
  useTable,
  useFilters,
  useRowSelect,
  useGlobalFilter,
  useAsyncDebounce,
  usePagination,
  useGroupBy,
  useSortBy } from 'react-table';
import Utils from '../../library/Utils';

// Define a default UI for filtering
export function GlobalFilter({
  preGlobalFilteredRows,
  globalFilter,
  setGlobalFilter,
}) {
  const count = preGlobalFilteredRows.length;
  const [value, setValue] = useState(globalFilter);
  const onChange = useAsyncDebounce(value => {
    setGlobalFilter(value || undefined)
  }, 200);

  return (
    <input className="inputs" id="global-filter" value={value || ""} onChange={e => {
        setValue(e.target.value);
        onChange(e.target.value);
      }} placeholder={`${count} record(s)`}
    />
  )
}

// Define a default UI for filtering
export function DefaultColumnFilter({
  column: { filterValue, setFilter, Header },
}) {
  return (
    <div className='table-filter-field-container'>
      <label>{Header}</label>
      <input className="inputs tb-filter-inputs tb-filter-default" value={filterValue || ''}
        placeholder={'Filter by ' + Header} onChange={e => {
          setFilter(e.target.value || undefined) // Set undefined to remove the filter entirely
        }}
      />
    </div>
  )
}

// This is a custom filter UI for selecting
// a unique option from a list
export function SelectColumnFilter({
  column: { filterValue, setFilter, preFilteredRows, id, Header },
}) {
  const options = React.useMemo(() => {
    const options = new Set()
    preFilteredRows.forEach(row => {
      options.add(row.values[id])
    })
    return [...options.values()]
  }, [id, preFilteredRows])

  return (
    <div className='table-filter-field-container'>
      <label>{Header}</label>
      <select className="inputs tb-filter-inputs" value={filterValue}
        onChange={e => {
          setFilter(e.target.value || undefined)
        }}
      >
        <option value="">All</option>
        {options.map((option, i) => (
          <option key={i} value={option}>
            {option}
          </option>
        ))}
      </select>
    </div>
  )
}

export function DateRangeColumnFilter({
  column: { filterValue = [], setFilter, Header },
}) {
  return (
    <div className='table-filter-field-container'>
      <label>{Header}</label>
      <div className='table-date-range-container'>
        <input value={filterValue[0] || ''} className="inputs tb-filter-inputs" type="date"
          onChange={e => {
            const val = e.target.value
            setFilter((old = []) => [val ? val : undefined, old[1]])
          }}
        />
        <span>to</span>
        <input value={filterValue[1] || ''} className="inputs tb-filter-inputs" type="date"
          onChange={e => {
            const val = e.target.value
            setFilter((old = []) => [old[0], val ? (val) : undefined]);
          }}
        />
      </div>
    </div>
  )
}

function fuzzyTextFilterFn(rows, id, filterValue) {
  return matchSorter(rows, filterValue, { keys: [row => row.values[id]] })
}

// Let the table remove the filter if the string is empty
fuzzyTextFilterFn.autoRemove = val => !val

function dateRangeFilterFn(rows, id, filterValues) {
  let start_date = new Date(filterValues[0]);
  let end_date = new Date(filterValues[1]);

  if(filterValues[0] !== undefined && filterValues[1] !== undefined) {
    return rows.filter(row => {
      let time = new Date(row.values[id]);
      if(filterValues.length === 0) {
        return rows;
      } else {
        return (
          time >= start_date && time <= end_date
        )
      }
    })
  } else {
    return rows;
  }
}

dateRangeFilterFn.autoRemove = val => !val;

// Our table component
export function Table(props) {
  const data = props.data;
  const columns = props.columns;
  const [pagination] = useState(props.pagination);
  const [isFilterShown, setFilterShown] = useState(false);
  const filterRef = useRef(null);

  const filterTypes = useMemo(
    () => ({
      fuzzyText: fuzzyTextFilterFn,
      dateRange: dateRangeFilterFn,
      text: (rows, id, filterValue) => {
        return rows.filter(row => {
          const rowValue = row.values[id]
          return rowValue !== undefined
            ? String(rowValue)
                .toLowerCase()
                .startsWith(String(filterValue).toLowerCase())
            : true
        })
      },
    }),
    []
  )

  const defaultColumn = useMemo(
    () => ({
      Filter: DefaultColumnFilter,
    }),
    []
  )

  useEffect(() => {
    function handleClickOutside(event) {
      if (filterRef.current && !filterRef.current.contains(event.target)) {
        setFilterShown(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside)
  }, [filterRef]);

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
    page,
    canPreviousPage,
    canNextPage,
    pageOptions,
    pageCount,
    gotoPage,
    nextPage,
    previousPage,
    state: { pageIndex, globalFilter },
    preGlobalFilteredRows,
    setGlobalFilter
  } = useTable(
    {
      columns,
      data,
      initialState: {
        pageIndex: 0, 
        pageSize: !Utils.isFieldEmpty(props.pageSize) ? props.pageSize[0] : data.length
      },
      defaultColumn,
      filterTypes
    },
    useFilters,
    useGlobalFilter,
    useGroupBy,
    useSortBy,
    usePagination,
    useRowSelect
  )

  let filterArray = [];
  headerGroups.forEach(headerGroup => {
    headerGroup.headers.forEach(column => {
      filterArray.push(
        column.canFilter ? column.render('Filter') : null
      )
    });
  });

  return (
    <>
    <div className='table-container'>
      {props.filterWithSearchBar === true &&
        <div className='tb-global-and-filter-container'>
          <GlobalFilter preGlobalFilteredRows={preGlobalFilteredRows} globalFilter={globalFilter} setGlobalFilter={setGlobalFilter} />
          <div className="tb-filter-container" ref={filterRef}>
            <button id="tb-filter-button" onClick={() => setFilterShown(!isFilterShown)}>
              <img src={"/assets/icons/filter.svg"} alt="" />
              Filter
            </button>
            {isFilterShown &&
              <div className="tb-filters">
                {filterArray.map(filter => (
                  filter
                ))}
              </div>
            }
          </div>
        </div>
      }
      <table {...getTableProps()} className={props.tableClass}>
        {props.showHeader !== false &&
          <thead className={props.tableExtra === true ? 'table-head-container' : null}>
            {props.filter === true &&
              <div className="tb-filter-container tb-filter-single" ref={filterRef}>
                <button id="tb-filter-button" onClick={() => setFilterShown(!isFilterShown)}>
                  <img src={"/assets/icons/filter.svg"} alt="" />
                  Filter
                </button>
                {isFilterShown &&
                  <div className="tb-filters">
                    {filterArray.map(filter => (
                      filter
                    ))}
                  </div>
                }
              </div>
            }
            {headerGroups.map(headerGroup => (
              <tr {...headerGroup.getHeaderGroupProps()}>
                {headerGroup.headers.map(column => (
                <th className="header-row" key={column.id} 
                  {...column.getHeaderProps(column.getSortByToggleProps())}>
                  {column.render('Header')}
                  <span>
                    {column.isSorted
                      ? column.isSortedDesc
                        ? '   🡣'
                        : '   🡡'
                      : column.disableSortBy === true ? '' : ' ⇅ Sort'
                    }
                  </span>
                </th>
                ))}
              </tr>
            ))}
          </thead>
        }
        <tbody {...getTableBodyProps()} className={props.tableExtra === true ? 'table-body-container scrollbar' : null}>
          {page.map((row, i) => {
            prepareRow(row)
            return (
              <tr {...row.getRowProps()} key={row.id} id={row.id} className={props.rowClass}>
                {row.cells.map(cell => {
                  return <td key={cell.id} {...cell.getCellProps()}>
                    {cell.render('Cell')}
                  </td>
                })}
              </tr>
            )
          })}
        </tbody>
      </table>
      {pagination && 
        <div className="pagination">
          <div className='pagination-arrows'>
            <button onClick={() => {
                previousPage();
                document.getElementById('pagination-input').value = pageIndex;
              }} disabled={!canPreviousPage}>
              <img src='/assets/icons/arrow_left_circle.svg' alt='' />
            </button>
          </div>
          <div className='pagination-center'>
            {pageOptions.map((page, i) => {
              return <button id={pageIndex === i ? "active-button-page" : null} onClick={() => gotoPage(i)}>{page + 1}</button>
            })}
          </div>
          <div className='pagination-arrows'>
            <button onClick={() => {
                nextPage();
                document.getElementById('pagination-input').value = pageIndex + 2;
              }} disabled={!canNextPage}>
              <img src='/assets/icons/arrow_ right_circle.svg' alt='' />
            </button>
          </div>
        </div>
      }
    </div>
    </>
  )
}

function filterGreaterThan(rows, id, filterValue) {
  return rows.filter(row => {
    const rowValue = row.values[id]
    return rowValue >= filterValue
  })
}

filterGreaterThan.autoRemove = val => typeof val !== 'number'