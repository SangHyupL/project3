module.exports.DATABASE_CONFIG = (serverless) => ({
  // dev에서 쓰이는 환경 변수
    dev: {
      DB_HOST: 'project3db2.cpajpop7ewnt.ap-northeast-2.rds.amazonaws.com',
      DB_USER: 'team8',
      DB_PASSWORD: 'team8',
      DATABASE: 'team8',
      TOPIC_ARN: 'arn:aws:sns:ap-northeast-2:775385743817:stock_empty'
    },
    // prod에서 쓰이는 환경 변수
    prod: {
      DB_HOST: 'project3db2.cpajpop7ewnt.ap-northeast-2.rds.amazonaws.com',
      DB_USER: 'team8',
      DB_PASSWORD: 'team8',
      DATABASE: 'team8',
      TOPIC_ARN: 'arn:aws:sns:ap-northeast-2:775385743817:stock_empty'
    }
});