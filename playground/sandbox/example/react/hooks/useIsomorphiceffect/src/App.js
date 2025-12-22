import useIsomorphicEffect from "../hook/useIsomorphicEffect";
import "./styles.css";

export default function App() {
  useIsomorphicEffect(() => {
    window.console.log("Hello");
  }, []);

  return (
    <div className="App">
      <h1>React useIsomporphicEffect hook</h1>
      <h2>Check out your console.</h2>
    </div>
  );
}
