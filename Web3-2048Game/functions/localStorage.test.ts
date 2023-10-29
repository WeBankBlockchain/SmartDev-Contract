import { getStoredData, setStoredData } from './localStorage';

const ITEM_NAME = '2048_data';

describe('localStorage', () => {
  it('writes data', () => {
    setStoredData({});
    expect(localStorage.getItem(ITEM_NAME)).toBe('{}');
  });

  it('reads data', () => {
    localStorage.setItem(ITEM_NAME, '{}');
    expect(getStoredData()).toMatchObject({});
  });

  it('discards invalid data', () => {
    localStorage.setItem(ITEM_NAME, '{"board":"wrong"}');
    expect(getStoredData()).toMatchObject({});
  });
});
