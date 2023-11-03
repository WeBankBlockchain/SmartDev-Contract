import { Direction } from '../types/Direction';
import { initializeBoard, newTileValue, updateBoard } from './board';

describe('board', () => {
  it('new tile value returns either 2 or 4', () => {
    expect([2, 4]).toContain(newTileValue());
  });

  it('initializes board with two non-zero tiles', () => {
    const boardSize = 4;
    const update = initializeBoard(boardSize);
    expect(update.board.length).toBe(boardSize ** 2);
    expect(update.board.filter(value => value === 0).length).toBe(
      boardSize ** 2 - 2
    );
  });

  it('moves tiles down', () => {
    const board = [0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0];
    const update = updateBoard(board, Direction.DOWN);
    expect(update.board[15]).toBe(4);
    expect(update.scoreIncrease).toBe(0);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(2);
  });

  it('moves tiles up', () => {
    const board = [0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0];
    const update = updateBoard(board, Direction.UP);
    expect(update.board[3]).toBe(4);
    expect(update.scoreIncrease).toBe(0);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(2);
  });

  it('moves tiles left', () => {
    const board = [0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0];
    const update = updateBoard(board, Direction.LEFT);
    expect(update.board[4]).toBe(4);
    expect(update.scoreIncrease).toBe(0);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(2);
  });

  it('moves tiles right', () => {
    const board = [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    const update = updateBoard(board, Direction.RIGHT);
    expect(update.board[7]).toBe(4);
    expect(update.scoreIncrease).toBe(0);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(2);
  });

  it('merges two tiles of the same value together', () => {
    const board = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 4];
    const update = updateBoard(board, Direction.DOWN);
    expect(update.board[15]).toBe(8);
    expect(update.scoreIncrease).toBe(8);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(2);
  });

  it("doesn't merge different tiles together", () => {
    const board = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 4];
    const update = updateBoard(board, Direction.DOWN);
    expect(update.board[15]).toBe(4);
    expect(update.scoreIncrease).toBe(0);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(2);
  });

  it('merges tiles in a non-greedy fashion: variant #1', () => {
    const board = [0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2];
    const update = updateBoard(board, Direction.DOWN);
    expect(update.board[15]).toBe(4);
    expect(update.board[11]).toBe(4);
    expect(update.scoreIncrease).toBe(8);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(3);
  });

  it('merges tiles in a non-greedy fashion: variant #2', () => {
    const board = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 4, 4];
    const update = updateBoard(board, Direction.RIGHT);
    expect(update.board[15]).toBe(8);
    expect(update.board[14]).toBe(8);
    expect(update.scoreIncrease).toBe(8);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(3);
  });

  it('merges tiles in a non-greedy fashion: variant #3', () => {
    const board = [0, 0, 0, 2, 0, 4, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2];
    const update = updateBoard(board, Direction.DOWN);
    expect(update.board[13]).toBe(4);

    // Make sure a new tile is generated.
    expect(update.board.filter(value => value !== 0).length).toBe(5);
  });
});
