/**
 * 记录日志
 */

import moment from 'moment';
import winston from 'winston';

require('winston-daily-rotate-file');

/**
 * 日志工具
 */
export default class Logger {
  /**
   * 单例
   *
   * @param {string} business
   * @param {string} _module
   * @param {string} project
   * @return {*}
   * @private
   */
  static getInstance(
      business = 'h5_auth', _module = 'api_info', project = 'mw_auth') {
    // 错误目录
    let logDir = process.env.NODE_ENV === 'dev'
        ? '/Users/Oo.../www/SeasLog'
        : '/var/log/application';

    return new winston.Logger({
      exitOnError: true,
      transports: [
        new (winston.transports.DailyRotateFile)({
          filename: project,
          dirname: logDir,
          datePattern: '-yyyyMMdd.log',
          localTime: true,
          json: false,
          handleExceptions: true,
          humanReadableUnhandledException: true,
          // exitOnError: false,
          formatter: function(options) {
            options.meta = options.meta || {};
            options.meta.msg = options.message;
            const defaults = {
              level: process.env.NODE_ENV == 'dev' ? 'debug' : 'info',
              time: moment().format('YYYY-MM-DD HH:mm:ss'),
              pid: process.pid,
              business: business,
              module: _module,
              datatype: 0,
            };
            return JSON.stringify(Object.assign({}, defaults, options.meta));
          },
        }),
      ],
    });
  }
}
