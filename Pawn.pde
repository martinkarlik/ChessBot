class Pawn extends Piece {

  Pawn(Piece pawn) {
    super(pawn);
    this.pieceValue = pawn.pieceValue;
    this.anpassant = pawn.anpassant;
    squaresCopy[x][y] = this;
  }
  
  Pawn(PVector boardPos_, boolean isWhite_) {
    super(boardPos_, isWhite_);
    pieceValue = 1.0*dir;
    anpassant = false;   
    squares[x][y] = this;
  }
  
  void display() {
    image(imgs[(1-int(isWhite))*6], pxPos.x, pxPos.y);  
  }
  
  void findLegalMoves(boolean onBoard) {
    Piece[][] tempSquares;
    if (onBoard) {
      tempSquares = squares; //see, here, I just need to reference to right thing, Im not making actual copy    
    } else {
      tempSquares = squaresCopy;  
    }
    legalMoves.clear();
    
    if (tempSquares[x][y+dir] == null) {
        legalMoves.add(new PVector(x, y+dir));
    }
    if (moves == 0 && tempSquares[x][y+dir] == null && tempSquares[x][y+2*dir] == null) {
        legalMoves.add(new PVector(x, y+2*dir));
    }
    if (x < 7 && tempSquares[x+1][y+dir] != null && tempSquares[x+1][y+dir].dir*dir < 0) { //if the checking square and the "whiteness" of the piece are not both positive/negative, then it's a legal move to go to that square and take that piece, cause it's of a different color
        if (tempSquares[x+1][y+dir] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }  
        } else {       
          legalMoves.add(new PVector(x+1, y+dir));
        }
    }
    if (x > 0 && tempSquares[x-1][y+dir] != null && tempSquares[x-1][y+dir].dir*dir < 0) {
      if (tempSquares[x-1][y+dir] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        } 
      } else {
        legalMoves.add(new PVector(x-1, y+dir));
      }
    }   
    if ((y == 3 || y == 4) && x > 0 && tempSquares[x-1][y] instanceof Pawn && tempSquares[x-1][y].moves == 1 && board.lastMove.x == tempSquares[x-1][y].boardPos.x && board.lastMove.y == tempSquares[x-1][y].boardPos.y) { //and it was hist last move
        legalMoves.add(new PVector(x-1, y+dir));      
        anpassant = true;
    }
    if ((y == 3 || y == 4) && x < 7 && tempSquares[x+1][y] instanceof Pawn && tempSquares[x+1][y].moves == 1 && board.lastMove.x == tempSquares[x+1][y].boardPos.x && board.lastMove.y == tempSquares[x+1][y].boardPos.y) {
        legalMoves.add(new PVector(x+1, y+dir));      
        anpassant = true;
    }
  }
  
  void reduceLegalMoves() {
    for (int i = legalMoves.size()-1; i >= 0; i--) {
      if (board.simulatePosition(this, boardToPx(legalMoves.get(i)))) {
        legalMoves.remove(i); 
        //println("Illegal: ", legalMoves.get(i)); 
      } else {
        //println("Legal: ", legalMoves.get(i));  
      }
    }  
  }
  
  void makeMove(PVector move, boolean onBoard) {
    super.makeMove(move, onBoard);
    if (y == 0 || y == 7) { //PROMOTION
      deletePiece(x, y, onBoard);
      if (board.whiteTurn) {
        board.whitePieces.add(new Queen(new PVector(x, y), isWhite));
      } else {
        board.blackPieces.add(new Queen(new PVector(x, y), isWhite));  
      }
    } else if (anpassant) {
      deletePiece(x, y-1, onBoard);
      if (onBoard) {
        squares[x][y] = this;
      } else { 
        squaresCopy[x][y] = this;
      }
      anpassant = false;
    } else {
      if (onBoard) {
        squares[x][y] = this; 
        board.whiteTurn = !board.whiteTurn;
      } else {
        squaresCopy[x][y] = this;  
      }
    }
  }  
}
