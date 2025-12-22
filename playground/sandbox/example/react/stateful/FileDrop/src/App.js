import FileDrop from "../component/FileDrop";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>File drag and drop area</h1>
      <FileDrop onDrop={console.log} />
    </div>
  );
}
