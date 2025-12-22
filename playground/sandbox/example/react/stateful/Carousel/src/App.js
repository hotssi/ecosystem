import Carousel from "../component/Carousel";
import "./styles.css";

export default function App() {
  return (
    <div className="App">
      <h1>Carousel</h1>
      <Carousel
        carouselItems={[
          <div>carousel item 1</div>,
          <div>carousel item 2</div>,
          <div>carousel item 3</div>
        ]}
      />
    </div>
  );
}
