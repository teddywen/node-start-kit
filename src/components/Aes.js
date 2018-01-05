/**
 * AES加密
 */

import crypto from 'crypto';

/**
 * ASE加密工具
 */
export default class aes {
  /**
   * 加密
   *
   * @param {string} data
   * @param {string} key
   * @return {string}
   */
  encrypt(data, key) {
    let iv = '';
    let clearEncoding = 'utf8';
    let cipherEncoding = 'base64';
    let cipherChunks = [];
    let cipher = crypto.createCipheriv('aes-256-ecb', key, iv);
    cipher.setAutoPadding(true);
    cipherChunks.push(cipher.update(data, clearEncoding, cipherEncoding));
    cipherChunks.push(cipher.final(cipherEncoding));
    return cipherChunks.join('');
  }

  /**
   * 解密
   *
   * @param {string} data
   * @param {string} key
   * @return {string}
   */
  decrypt(data, key) {
    let iv = '';
    let clearEncoding = 'utf8';
    let cipherEncoding = 'base64';
    let cipherChunks = [];
    let decipher = crypto.createDecipheriv('aes-256-ecb', key, iv);
    decipher.setAutoPadding(true);
    cipherChunks.push(decipher.update(data, cipherEncoding, clearEncoding));
    cipherChunks.push(decipher.final(clearEncoding));
    return cipherChunks.join('');
  }
}
