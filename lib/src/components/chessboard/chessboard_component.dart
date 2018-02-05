part of chessboard;
@Component(
  selector: "chessboard",
  directives: const[ChessFieldComponent,NgFor],
  template: """
    <chessfield *ngFor='let index of indices' [index]='index'></chessfield>
    """,
  styles: const[
    """
      :host:{
        display: block;
        width: 800px;
      }
    """
  ]
)
class ChessBoardComponent{
  final List<int> indices = new List.generate(64,(i)=>i);

}