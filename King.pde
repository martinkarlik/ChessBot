class King extends Piece {
  
  King(Piece king) {
    super(king);
    this.pieceValue = king.pieceValue;
    this.castle = king.castle;
    squaresCopy[x][y] = this;
  }
  
  King(PVector boardPos_, boolean isWhite_) {
    super(boardPos_, isWhite_);
    pieceValue = 4.0*dir;
    castle = 0;
    
    squares[x][y] = this; 
  }
  
  void display() {
    image(imgs[(1-int(isWhite))*6+5], pxPos.x, pxPos.y); 
  }
  
  int sgn(float x) { 
    if (abs(x) < 0.1) { //the cos and sin functions make weird stuff with the argument - cos(90) is something like 1.1E-10 (something close to 0, but not exactly 0), thus this condition
      return 0;  
    }
    return int(x/abs(x));
  }
  
  void findLegalMoves(boolean onBoard) {
    Piece[][] tempSquares;
    if (onBoard) {
      tempSquares = squares; //see, here, I just need to reference to right thing, Im not making actual copy    
    } else {
      tempSquares = squaresCopy;  
    }
    legalMoves.clear();
    
    for (float alfa = 0; alfa < TWO_PI; alfa += QUARTER_PI) { //just a fancy way to find the legal moves for the king, taking adva of trigonometry #blessYouTrigonometry 
      int tempX = x+sgn(cos(alfa));
      int tempY = y+sgn(sin(alfa));
      if (tempX < 8 && tempX >= 0 && tempY < 8 && tempY >= 0 && (tempSquares[tempX][tempY] == null || tempSquares[tempX][tempY].dir*dir < 0 && !(tempSquares[tempX][tempY] instanceof King))) {
        legalMoves.add(new PVector(tempX, tempY));  
      }
    }
    
    if (moves == 0) { //can the king castle? well, there's couple of conditions
      if (tempSquares[x+1][y] == null && tempSquares[x+2][y] == null && tempSquares[x+3][y] instanceof Rook && tempSquares[x+3][y].moves == 0) {
        legalMoves.add(new PVector(x+2, y));   
        castle = 1;
      }
      if (tempSquares[x-1][y] == null && tempSquares[x-2][y] == null && tempSquares[x-3][y] == null && tempSquares[x-4][y] instanceof Rook && tempSquares[x-4][y].moves == 0) {
        legalMoves.add(new PVector(x-2, y)); 
        castle = -1;  
      }
    }
  }
  
  void reduceLegalMoves() {
    for (int i = legalMoves.size()-1; i >= 0; i--) {
      if (board.simulatePosition(this, boardToPx(legalMoves.get(i)))) {
        legalMoves.remove(i);  
      }
    }  
  }
  
  void makeMove(PVector move, boolean onBoard) {
    super.makeMove(move, onBoard);
    if (onBoard) {
      squares[x][y] = this;
    } else {
      squaresCopy[x][y] = this;  
    }
    if (castle == 1) { //short castles
      PVector newMove = boardToPx(new PVector(x-1,y));
      squares[x+1][y].makeMove(newMove, onBoard); //move will be ended by the rook
      castle = 0;
    } else if (castle == -1) { //long castles
      PVector newMove = boardToPx(new PVector(x+1,y));
      squares[x-2][y].makeMove(newMove, onBoard); 
      castle = 0;
    } else { //if the turn has not been castles, it is up to the king to end the move (otherwise, the rook takes care of it, but important is, someone (and only one piece) has to end the move)
      if (onBoard) {
        board.whiteTurn = !board.whiteTurn;
      }
    }
  }
}
