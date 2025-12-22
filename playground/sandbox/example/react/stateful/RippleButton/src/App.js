import RippleButton from "../component/RippleButton";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Button with ripple effect</h1>
      <RippleButton onClick={(e) => console.log(e)}>Click me</RippleButton>
    </div>
  );
}
