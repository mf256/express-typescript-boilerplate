import request from 'supertest';
process.env.NODE_ENV = 'test';

describe('loading express', () => {
  let server;
  beforeEach(() => {
    server = require('../app');
  });

  it('responds to /', function testSlash(done) {
    request(server)
      .get('/')
      .expect(200, done);
  });
  it('404 everything else', function testPath(done) {
    request(server)
      .get('/foo/bar')
      .expect(404, done);
  });
});
