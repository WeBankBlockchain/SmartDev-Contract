import { createStore } from 'redux';

import reducers, { StoreType } from './reducers';

const newStore = (): StoreType => createStore(reducers);
export default newStore;
