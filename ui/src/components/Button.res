@react.component
let make = (~children, ~onClick, ~loading=false, ~disabled=false) => {
  <button
    className={`w-full bg-blue-500 py-2 px-4 rounded hover:bg-blue-600 transition-colors relative ${disabled
        ? "opacity-60 pointer-events-none"
        : ""}`}
    onClick>
    <div
      className={`absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 ${!loading
          ? "opacity-0"
          : ""}`}>
      <Spinner />
    </div>
    <span className={loading ? "opacity-0" : ""}> {children->React.string} </span>
  </button>
}
