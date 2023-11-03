import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { StateType } from '../reducers';
import { Direction } from '../types/Direction';
import { Point } from '../types/Models';
import { BoardType } from '../functions/board';
import { Animation, AnimationType } from '../types/Animations';
import { animationDuration } from '../config';
import { moveAction } from '../actions';
import BoardTile from './BoardTile';
import Overlay from './Overlay';

const Board: React.FC = () => {
  const dispatch = useDispatch();
  const board = useSelector((state: StateType) => state.board);
  const boardSize = useSelector((state: StateType) => state.boardSize);
  const animations = useSelector((state: StateType) => state.animations);
  const startPointerLocation = useRef<Point>();
  const currentPointerLocation = useRef<Point>();

  const onMove = useCallback(
    (direction: Direction) => dispatch(moveAction(direction)),
    [dispatch]
  );

  const [renderedBoard, setRenderedBoard] = useState(board);
  const [renderedAnimations, setRenderedAnimations] = useState<Animation[]>([]);
  const lastBoard = useRef<BoardType>([...board]);
  const animationTimeout = useRef<any>();

  useEffect(() => {
    const keydownListener = (e: KeyboardEvent) => {
      e.preventDefault();

      switch (e.key) {
        case 'ArrowDown':
          onMove(Direction.DOWN);
          break;
        case 'ArrowUp':
          onMove(Direction.UP);
          break;
        case 'ArrowLeft':
          onMove(Direction.LEFT);
          break;
        case 'ArrowRight':
          onMove(Direction.RIGHT);
          break;
      }
    };

    window.addEventListener('keydown', keydownListener);

    return () => {
      window.removeEventListener('keydown', keydownListener);
    };
  }, [onMove]);

  const finishPointer = useCallback(
    (a: Point, b: Point) => {
      const distance = Math.sqrt((b.y - a.y) ** 2 + (b.x - a.x) ** 2);
      if (distance < 20) {
        return;
      }

      const angle = (Math.atan2(b.y - a.y, b.x - a.x) * 180) / Math.PI;
      if (angle < -135 || angle > 135) {
        onMove(Direction.LEFT);
      } else if (angle < -45) {
        onMove(Direction.UP);
      } else if (angle < 45) {
        onMove(Direction.RIGHT);
      } else if (angle < 135) {
        onMove(Direction.DOWN);
      }
    },
    [onMove]
  );

  const onTouchStart = useCallback((e: React.TouchEvent) => {
    e.preventDefault();
    const touch = e.touches[0];
    if (touch) {
      const point: Point = { x: touch.pageX, y: touch.pageY };
      startPointerLocation.current = point;
    }
  }, []);
  const onTouchMove = useCallback((e: React.TouchEvent) => {
    e.preventDefault();
    const touch = e.touches[0];
    if (touch) {
      const point: Point = { x: touch.pageX, y: touch.pageY };
      currentPointerLocation.current = point;
    }
  }, []);
  const onTouchEnd = useCallback(
    (e: React.TouchEvent) => {
      e.preventDefault();
      if (startPointerLocation.current && currentPointerLocation.current) {
        finishPointer(
          startPointerLocation.current,
          currentPointerLocation.current
        );
      }

      startPointerLocation.current = undefined;
      currentPointerLocation.current = undefined;
    },
    [finishPointer]
  );

  const onMouseStart = useCallback((e: React.MouseEvent) => {
    const point: Point = { x: e.pageX, y: e.pageY };
    startPointerLocation.current = point;
  }, []);
  const onMouseEnd = useCallback(
    (e: React.MouseEvent) => {
      if (startPointerLocation.current) {
        finishPointer(startPointerLocation.current, { x: e.pageX, y: e.pageY });
        startPointerLocation.current = undefined;
      }
    },
    [finishPointer]
  );

  useEffect(() => {
    if (!animations) {
      setRenderedBoard([...board]);
      return;
    }

    const moveAnimations = animations.filter(
      animation => animation.type === AnimationType.MOVE
    );
    const otherAnimations = animations.filter(
      animation => animation.type !== AnimationType.MOVE
    );

    if (moveAnimations.length > 0) {
      setRenderedBoard(lastBoard.current);
      setRenderedAnimations(moveAnimations);

      clearTimeout(animationTimeout.current);
      animationTimeout.current = setTimeout(() => {
        setRenderedAnimations(otherAnimations);
        setRenderedBoard([...board]);
      }, animationDuration);
    } else {
      setRenderedAnimations(otherAnimations);
      setRenderedBoard([...board]);
    }

    lastBoard.current = [...board];
  }, [animations, board, setRenderedBoard, setRenderedAnimations]);

  return (
    <div
      className={`board board-${boardSize}`}
      style={{ '--board-size': boardSize } as any}
      onMouseDown={onMouseStart}
      onMouseUp={onMouseEnd}
      onMouseLeave={onMouseEnd}
      onTouchStart={onTouchStart}
      onTouchMove={onTouchMove}
      onTouchEnd={onTouchEnd}
    >
      {renderedBoard.map((value, i) => (
        <BoardTile
          value={value}
          key={i}
          animations={renderedAnimations?.filter(
            animation => animation.index === i
          )}
        />
      ))}
      <Overlay />
    </div>
  );
};

export default Board;
