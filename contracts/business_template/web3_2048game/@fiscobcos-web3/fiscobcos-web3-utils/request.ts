import axios, { AxiosResponse } from 'axios';

// Sample fetcher
export const fetcher = <T>(url: string, config?: RequestInit) => {
    // Default request method
    // You can override these defaults by passing in a configuration object.
    /**
     *  const data = await fetcher<T>('http://example.com', {
     *      // Here, we're only overriding the request body.
     *      body: JSON.stringify({ key: 'value' }) 
     *  });
     */
    const defaultConfig: RequestInit = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
    };
    const finalConfig = { ...defaultConfig, ...config };
  
    return fetch(url, finalConfig).then((res: Response) => res.json() as Promise<T>);
  };
  
// eslint-disable-next-line no-restricted-globals
export const request = async (url: string, method: string, headers: any, requestBody?:any):Promise<AxiosResponse<any, any>> => {
    let resp;
    if (method === 'post' || method.toLowerCase() === 'post') {
        resp = await axios.post(url, requestBody, {headers: headers});
    }

    if (method === 'get' || method.toLowerCase() === 'get') {
        resp = await axios.get(url, requestBody);
    }

    return resp as any;
}