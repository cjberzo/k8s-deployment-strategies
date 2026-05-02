import http from 'k6/http';

export const options = {
  vus: 10,        // usuarios virtuales
  duration: '10s' // duración
};

export default function () {
  const res = http.get('http://192.168.49.2:30007');
  console.log(res.body);
}