import TextArea from "../component/TextArea";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Uncontrolled textarea element</h1>
      <TextArea
        placeholder="Insert some text here..."
        onValueChange={(val) => alert(val)}
      />
    </div>
  );
}
