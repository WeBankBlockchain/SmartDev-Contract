import { ActionModel } from '../types/Models';
import { ActionType } from '../types/ActionType';
import { Direction } from '../types/Direction';

export function resetAction(size = 4): ActionModel {
  return {
    type: ActionType.RESET,
    value: size,
  };
}

export function undoAction(): ActionModel {
  return {
    type: ActionType.UNDO,
  };
}

export function moveAction(direction: Direction): ActionModel {
  return {
    type: ActionType.MOVE,
    value: direction,
  };
}

export function dismissAction(): ActionModel {
  return {
    type: ActionType.DISMISS,
  };
}
