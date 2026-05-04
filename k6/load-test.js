import http from 'k6/http';

const BASE_URL = __ENV.BASE_URL;

export const options = {
  vus: 10,
  duration: '10s'
};

export default function () {
  const res = http.get(BASE_URL);
  console.log(res.body);
}