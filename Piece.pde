class Piece {
  PVector boardPos;
  PVector pxPos;
  PVector priorPxPos; 
  boolean isWhite;
  ArrayList<PVector> legalMoves;
  boolean isPicked;
  int moves;
  int x; //additional variables to help simplify the look of the code (mostly the function findLegalMoves())
  int y;
  int dir; //direction => positive for white pieces, negative for black pieces (-1/1), simplifies calculations (e.g. can I capture this piece? is this piece of a different color? is my dir * opponent's dir a negative number? simple condition thanks to this variable)
  float pieceValue;
  boolean anpassant; //even though this var is specific for Pawn, (and castle for King), when creating a copy of an object, it doesnt know what subclass it is, therefore it needs an access to all the variables (just in case it is a pawn)
  int castle;
  
  Piece(Piece piece) { //this is a copy constructor, making it possible to make a new object identical to another object, but as two different objects, not just two references to the same object 
    this.boardPos = piece.boardPos; //this copy constructor is important for creating a copy of the objects, to simulate a move (but not actually play it) - we want to make a move, but on a "imaginary" board
    this.pxPos = piece.pxPos; 
    this.isWhite = piece.isWhite;
    this.moves = piece.moves;
    this.dir = piece.dir;
    this.x = piece.x;
    this.y = piece.y;    
  }
  
  Piece(PVector boardPos_, boolean isWhite_) {
    boardPos = boardPos_; //I wanna think about the board position similarly as in real chess 
    pxPos = boardToPx(new PVector(boardPos.x, boardPos.y));
    isWhite = isWhite_;
    isPicked = false;
    moves = 0;
    dir = isWhiteInt(isWhite);
    x = int(boardPos.x); 
    y = int(boardPos.y);
    legalMoves = new ArrayList<PVector>();
    priorPxPos = pxPos.copy(); //I need to remember the prior piece position to recognize, if the player returned a piece to the same square
  }
  
  PVector boardToPx(PVector pos) { //translates board position to pixel coordinates 
    //instance of a class as an argument behaves actually as pass-by-reference - it modifies the argument, but that's what I want it to do (just gotta be careful when calling the function)
    pos.y = 7 - pos.y; //pixel[0, 0] is in the top left corner, but I want to think about the board[0, 0] in the bottom left corner to resemble real chess and make it easier to work with
    return pos.mult(scl);  
  }
  
  PVector pxToBoard(PVector pos) { //translates pixel coordinates to board position (modifies the argument)
    pos.x = floor(pos.x/scl);
    pos.y = 7 - floor(pos.y/scl);
    return pos;
  }
  
  void display() {
    //image(img, x, y);
  }
   
  int isWhiteInt(boolean isWhite) { 
    return int((float(int(isWhite))-0.5)*2); //true/false => -1/1
  }
  
  void illegalMove() {
    println("NOPE"); //some animation
    pxPos = priorPxPos.copy();
  }
  
  void deletePiece(int x, int y, boolean onBoard) { //deletes piece from a square (after a capture or promotion)
    if (onBoard) {    
      if (squares[x][y] != null) { //if there is nothing on the square, there is nothing to be removed
        if (board.whiteTurn) {
            for (int i = 0; i < board.blackPieces.size(); i++) {
              if (board.blackPieces.get(i).x == x && board.blackPieces.get(i).y == y) {
                board.blackPieces.remove(i);
                break;
              }
            }
          } else {
            for (int i = 0; i < board.whitePieces.size(); i++) {
              if (board.whitePieces.get(i).x == x && board.whitePieces.get(i).y == y) {
                board.whitePieces.remove(i);
                break;
              }  
            }
          }
          squares[x][y] = null;
      }
    } else {
      if (squaresCopy[x][y] != null) { //if there is nothing on the square, there is nothing to be removed
        if (board.whiteTurn) {
            for (int i = 0; i < board.blackPiecesCopy.size(); i++) {
              if (board.blackPiecesCopy.get(i).x == x && board.blackPiecesCopy.get(i).y == y) {
                board.blackPiecesCopy.remove(i);
                break;
              }
            }
          } else {
            for (int i = 0; i < board.whitePiecesCopy.size(); i++) {
              if (board.whitePiecesCopy.get(i).x == x && board.whitePiecesCopy.get(i).y == y) {
                board.whitePiecesCopy.remove(i);
                break;
              }  
            }
          }
          squaresCopy[x][y] = null;
      }  
    }
  }
  
  void makeMove(PVector pos, boolean onBoard) {
    if (onBoard) {
      squares[x][y] = null; //the old square is now empty, piece is on a new square
    } else {
      squaresCopy[x][y] = null;
    }
    boardPos = pxToBoard(pos);
    x = int(boardPos.x);
    y = int(boardPos.y);
    deletePiece(x, y, onBoard);
    pxPos = boardToPx(boardPos.copy()); 
    moves++;
    board.lastMove = pos;
  }
  
  void findLegalMoves(boolean onBoard) { 
  }
  
  void reduceLegalMoves() {
  }
  
  boolean inLegalMoves(PVector move) {
    move = pxToBoard(move);
    return legalMoves.contains(move); 
  }
}
