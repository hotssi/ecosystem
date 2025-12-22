import { useState } from "react";
import useEffectOnce from "../hook/useEffectonce";
import "./styles.css";

export default function App() {
  const [clicked, setClicked] = useState(false);
  useEffectOnce(() => {
    console.log("mounted");
  }, clicked);

  return (
    <div className="App">
      <h1>React useEffectOnce hook</h1>
      <button onClick={() => setClicked(true)}>Click me</button>
    </div>
  );
}
