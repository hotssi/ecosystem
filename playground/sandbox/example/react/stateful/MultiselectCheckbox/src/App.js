import MultiselectCheckbox from "../component/MultiselectCheckbox";
import "./styles.css";

export default function App() {
  const options = [{ label: "Item One" }, { label: "Item Two" }];

  return (
    <div className="App">
      <h1>Multiple Select Checkbox</h1>
      <MultiselectCheckbox
        options={options}
        onChange={(data) => {
          console.log(data);
        }}
      />
    </div>
  );
}
