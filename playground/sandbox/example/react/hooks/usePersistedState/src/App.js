import MyComponent from "../component/MyComponent";
import { useState } from "react";
import "./styles.css";

export default function App() {
  const [name, setName] = useState("my-value");
  return (
    <div className="App">
      <h1>React usePersistedState hook</h1>
      <MyComponent name={name} />
      <input
        value={name}
        onChange={(e) => {
          setName(e.target.value);
        }}
      />
    </div>
  );
}
