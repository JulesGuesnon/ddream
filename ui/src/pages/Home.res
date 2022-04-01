@react.component
let make = () => {
  <main className="w-full h-full flex justify-center items-center">
    <div className="text-center">
      <p className="text-6xl"> {"An awesome website"->React.string} </p>
      <p className="text-2xl mt-4 text-gray-400"> {"I think so"->React.string} </p>
    </div>
  </main>
}
