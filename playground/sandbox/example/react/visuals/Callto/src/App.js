import Callto from "../component/Callto";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Callable telephone link</h1>
      <Callto phone="+302101234567">Call me!</Callto>
    </div>
  );
}
