part of chessboard;

@Component(
  selector: "piece",
  template: """
    
  """,
  styles: const[
    """
      :host{
        border-radius: 1000000px;
        border: 2px solid #aaa;
        display: block;
        width: 60%;
        height: 60%;
        position:relative;
        left: 20%;
        top: 20%;
        background-color: white;
      }
      :host(.black){
        background-color: black;
      }
      :host(.active){
        border: 5px solid red;
      }
    """
  ]
)
class PieceComponent{
  bool isActive;
}