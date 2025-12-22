import Counter from "../component/Counter";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Tip: Label your useState values in React developer tools</h1>
      {/* Inspecting `Counter` in React developer tools will display: */}
      {/* StateWithLabel: "counter: 0" */}
      <Counter />
    </div>
  );
}
