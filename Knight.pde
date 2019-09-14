class Knight extends Piece {
  
  Knight(Piece knight) {
    super(knight);
    this.pieceValue = knight.pieceValue;
    squaresCopy[x][y] = this;
  }
  
  Knight(PVector boardPos_, boolean isWhite_) {
    super(boardPos_, isWhite_);
    pieceValue = 3.0*dir;
    
    squares[x][y] = this; 
  }
  
  void display() {
    image(imgs[(1-int(isWhite))*6+2], pxPos.x, pxPos.y);  
  }
  
  void findLegalMoves(boolean onBoard) {
    Piece[][] tempSquares;
    if (onBoard) {
      tempSquares = squares; //see, here, I just need to reference to right thing, Im not making actual copy    
    } else {
      tempSquares = squaresCopy;  
    }
    legalMoves.clear();
    if (x+2 < 8 && y+1 < 8 && (tempSquares[x+2][y+1] == null || tempSquares[x+2][y+1].dir*dir < 0)) { //if not for short-circuiting this would throw null pointer exceptions #blessYouShortCircuiting
      if (tempSquares[x+2][y+1] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x+2, y+1));
      }
    }
    if (x-2 >= 0 && y+1 < 8 && (tempSquares[x-2][y+1] == null || tempSquares[x-2][y+1].dir*dir < 0)) { 
      if (tempSquares[x-2][y+1] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x-2, y+1));
      }
    }
    if (x+2 < 8 && y-1 >= 0 && (tempSquares[x+2][y-1] == null || tempSquares[x+2][y-1].dir*dir < 0)) { 
      if (tempSquares[x+2][y-1] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x+2, y-1));
      }
    }
    if (x-2 >= 0 && y-1 >= 0 && (tempSquares[x-2][y-1] == null || tempSquares[x-2][y-1].dir*dir < 0)) { 
      if (tempSquares[x-2][y-1] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x-2, y-1));
      }
    }
    if (x+1 < 8 && y+2 < 8 && (tempSquares[x+1][y+2] == null || tempSquares[x+1][y+2].dir*dir < 0)) { 
      if (tempSquares[x+1][y+2] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x+1, y+2));
      }
    }
    if (x-1 >= 0 && y+2 < 8 && (tempSquares[x-1][y+2] == null || tempSquares[x-1][y+2].dir*dir < 0)) { 
      if (tempSquares[x-1][y+2] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x-1, y+2));
      }
    }
    if (x+1 < 8 && y-2 >= 0 && (tempSquares[x+1][y-2] == null || tempSquares[x+1][y-2].dir*dir < 0)) { 
      if (tempSquares[x+1][y-2] instanceof King) {
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x+1, y-2));
      }
    }
    if (x-1 >= 0 && y-2 >= 0 && (tempSquares[x-1][y-2] == null || tempSquares[x-1][y-2].dir*dir < 0)) { 
      if (tempSquares[x-1][y-2] instanceof King) { //maybe if it is null AND instance of king.. hope it wont be a problem
        if (onBoard) {
          board.check = true;
        } else {
          board.checkCopy = true;  
        }
      } else {
        legalMoves.add(new PVector(x-1, y-2));
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
      board.whiteTurn = !board.whiteTurn;
    } else {
      squaresCopy[x][y] = this;  
    }
  }
}
