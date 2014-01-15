<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
class gz {
    
    
//--------------------------------------------------------------------------------------------------------------------------------------------	
// Корректная gzip функция
//--------------------------------------------------------------------------------------------------------------------------------------------
  public static function gzencode_zip($data) {
      return gzencode($data);      
  }
    
    
//--------------------------------------------------------------------------------------------------------------------------------------------	
// Корректная gzip функция
//--------------------------------------------------------------------------------------------------------------------------------------------
  public static function gzdecode_zip($data) {
              $len = strlen($data);
              if ($len < 18 || strcmp(substr($data,0,2),"\x1f\x8b")) {
                return null;  
              }
              $method = ord(substr($data,2,1));  
              $flags  = ord(substr($data,3,1));  
              if ($flags & 31 != $flags) {    
                return null;
              }
              $headerlen = 10;
              $extralen  = 0;
              $extra     = "";
              if ($flags & 4) {

                if ($len - $headerlen - 2 < 8) {
                  return false;   
                }
                $extralen = unpack("v",substr($data,8,2));
                if ($len - $headerlen - 2 - $extralen[1] < 8) {
                  return false;   
                }
                $extra = substr($data,10,$extralen[1]);
                $headerlen += 2 + $extralen[1];
              }

              $filenamelen = 0;
              $filename = "";
              if ($flags & 8) {

                if ($len - $headerlen - 1 < 8) {
                  return false; 
                }
                $filenamelen = strpos(substr($data,8+$extralen[1]),chr(0));
                if ($filenamelen === false || $len - $headerlen - $filenamelen - 1 < 8) {
                  return false;   
                }
                $filename = substr($data,$headerlen,$filenamelen);
                $headerlen += $filenamelen + 1;
              }

              $commentlen = 0;
              $comment = "";
              if ($flags & 16) {

                if ($len - $headerlen - 1 < 8) {
                  return false;  
                }
                $commentlen = strpos(substr($data,8+$extralen[1]+$filenamelen),chr(0));
                if ($commentlen === false || $len - $headerlen - $commentlen - 1 < 8) {
                  return false;  
                }
                $comment = substr($data,$headerlen,$commentlen);
                $headerlen += $commentlen + 1;
              }

              $headercrc = "";
              if ($flags & 2) {

                if ($len - $headerlen - 2 < 8) {
                  return false;   
                }
                $calccrc = crc32(substr($data,0,$headerlen)) & 0xffff;
                $headercrc = unpack("v", substr($data,$headerlen,2));
                if ($headercrc[1] != $calccrc) {
                  return false;  
                }
                $headerlen += 2;
              }


              $datacrc = unpack("V",substr($data,-8,4));
              $isize = unpack("V",substr($data,-4));

              $bodylen = $len-$headerlen-8;
              if ($bodylen < 1) {

                return null;
              }
              $body = substr($data,$headerlen,$bodylen);
              $data = "";
              if ($bodylen > 0) {
                switch ($method) {
                  case 8:

                    $data = gzinflate($body);
                    break;
                  default:

                    return false;
                }
              } 
              if ($isize[1] != strlen($data) || crc32($data) != $datacrc[1]) {
                return false;
              }
              return $data;
            }            
}

