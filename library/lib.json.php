<?php
/*
* Autor Andrey Lysikov (C) 2014
* Licensed under the MIT license:
*   http://www.opensource.org/licenses/mit-license.php
* Part of IWS system
*/
class json {
	static function get_about() {
			return "Независимая работа со строками и массивами JSON";
	}
    //--------------------------------------------------------------------------------------------------------------------------------------------
    // Свои функции json encode и json decode в связи с php > 5.5.5
    //--------------------------------------------------------------------------------------------------------------------------------------------
   function jsondecode($json, $assoc = false) {
                    mb_internal_encoding("UTF-8");
                    $i = 0;
                    $n = strlen($json);
                    try {
                        $result = $this -> json_decode_value($json, $i, $assoc);
                        while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                        if ($i < $n) {
                            return null;
                        }
                        return $result;
                    } catch (Exception $e) {
                        return null;
                    }                

               }

            private function json_decode_value($json, &$i, $assoc = false)
                    {
                    $n = strlen($json);
                    while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;

                    switch ($json[$i]) {
                            // object
                        case '{':
                            $i++;
                            $result = $assoc ? array() : new stdClass();
                                while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                if ($json[$i] === '}') {
                                    $i++;
                                    return $result;
                                }
                                while ($i < $n) {
                                    $key = $this -> json_decode_string($json, $i);
                                    while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                    if ($json[$i++] != ':') {
                                        throw new Exception("Expected ':' on ".($i - 1));
                                    }
                                    if ($assoc) {
                                        $result[$key] = $this -> json_decode_value($json, $i, $assoc);
                                    } else {
                                        $result->$key = $this -> json_decode_value($json, $i, $assoc);
                                    }
                                    while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                    if ($json[$i] === '}') {
                                        $i++;
                                        return $result;
                                    }
                                    if ($json[$i++] != ',') {
                                        throw new Exception("Expected ',' on ".($i - 1));
                                    }
                                    while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                }
                                throw new Exception("Syntax error");
                        // array
                        case '[':
                            $i++;
                            $result = array();
                                while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                if ($json[$i] === ']') {
                                    $i++;
                                    return array();
                                }
                                while ($i < $n) {
                                    $result[] = $this ->  json_decode_value($json, $i, $assoc);
                                    while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                    if ($json[$i] === ']') {
                                        $i++;
                                        return $result;
                                    }
                                    if ($json[$i++] != ',') {
                                        throw new Exception("Expected ',' on ".($i - 1));
                                    }
                                    while ($i < $n && $json[$i] && $json[$i] <= ' ') $i++;
                                }                    
                                throw new Exception("Syntax error");
                        // string
                        case '"':
                            return $this -> json_decode_string($json, $i);
                        // number
                        case '-':
                            return $this -> json_decode_number($json, $i);
                        // true
                        case 't':
                             if ($i + 3 < $n && substr($json, $i, 4) === 'true') {
                                 $i += 4;
                                 return true;
                             }
                        // false
                        case 'f':
                             if ($i + 4 < $n && substr($json, $i, 5) === 'false') {
                                 $i += 5;
                                 return false;
                             }
                        // null
                        case 'n':
                             if ($i + 3 < $n && substr($json, $i, 4) === 'null') {
                                 $i += 4;
                                 return null;
                             }            
                        default:
                                // number
                            if ($json[$i] >= '0' && $json[$i] <= '9') {
                                return $this -> json_decode_number($json, $i);
                            } else {
                                throw new Exception("Syntax error");
                            }
                }
              }

              private function json_decode_string($json, &$i)
                    {
                    $result = '';
                    $escape = array('"' => '"', '\\' => '\\', '/' => '/', 'b' => "\b", 'f' => "\f", 'n' => "\n", 'r' => "\r", 't' => "\t");
                    $n = strlen($json);
                    if ($json[$i] === '"') {
                        while (++$i < $n) {
                            if ($json[$i] === '"') {
                                $i++;
                                return $result;
                            } elseif ($json[$i] === '\\') {
                                $i++;
                                if ($json[$i] === 'u') {
                                    $code = "&#".hexdec(substr($json, $i + 1, 4)).";";
                                    $convmap = array(0x80, 0xFFFF, 0, 0xFFFF);
                                    $result .= mb_decode_numericentity($code, $convmap, 'UTF-8');
                                    $i += 4;
                                } elseif (isset($escape[$json[$i]])) {
                                    $result .= $escape[$json[$i]];
                                } else {
                                    break;
                                }
                            } else {
                                $result .= $json[$i];
                            }
                        }
                    }
                         throw new Exception("Syntax error");                 
              }

            private function json_decode_number($json, &$i)
                    {
                    $result = '';
                    if ($json[$i] === '-') {
                        $result = '-';
                        $i++;
                    }
                    $n = strlen($json);
                    while ($i < $n && $json[$i] >= '0' && $json[$i] <= '9') {
                        $result .= $json[$i++];
                    }

                    if ($i < $n && $json[$i] === '.') {
                        $result .= '.';
                        $i++;
                        while ($i < $n && $json[$i] >= '0' && $json[$i] <= '9') {
                            $result .= $json[$i++];
                        }
                    }
                    if ($i < $n && ($json[$i] === 'e' || $json[$i] === 'E')) {
                        $result .= $json[$i];
                        $i++;
                        if ($json[$i] === '-' || $json[$i] === '+') {
                            $result .= $json[$i++];
                        }
                        while ($i < $n && $json[$i] >= '0' && $json[$i] <= '9') {
                            $result .= $json[$i++];
                        }
                    }

                    return (0 + $result);                
                }

             function jsonencode($value) 
                {
                    if (is_int($value)) {
                        return (string)$value;   
                    } elseif (is_string($value)) {
                            $value = str_replace(array('\\', '/', '"', "\r", "\n", "\b", "\f", "\t"), 
                                                 array('\\\\', '\/', '\"', '\r', '\n', '\b', '\f', '\t'), $value);
                            $convmap = array(0x80, 0xFFFF, 0, 0xFFFF);
                            $result = "";
                            for ($i = mb_strlen($value) - 1; $i >= 0; $i--) {
                                $mb_char = mb_substr($value, $i, 1);
                                if (mb_ereg("&#(\\d+);", mb_encode_numericentity($mb_char, $convmap, "UTF-8"), $match)) {
                                    $result = sprintf("\\u%04x", $match[1]) . $result;
                                } else {
                                    $result = $mb_char . $result;
                                }
                            }
                            return '"' . $result . '"';                
                    } elseif (is_float($value)) {
                        return str_replace(",", ".", $value);         
                    } elseif (is_null($value)) {
                        return 'null';
                    } elseif (is_bool($value)) {
                        return $value ? 'true' : 'false';
                    } elseif (is_array($value)) {
                        $with_keys = false;
                        $n = count($value);
                        for ($i = 0, reset($value); $i < $n; $i++, next($value)) {
                                    if (key($value) !== $i) {
                                          $with_keys = true;
                                          break;
                                    }
                        }
                    } elseif (is_object($value)) {
                        $with_keys = true;
                    } else {
                        return '';
                    }
                    $result = array();
                    if ($with_keys) {
                        foreach ($value as $key => $v) {
                            $result[] = $this -> jsonencode((string)$key) . ':' . $this -> jsonencode($v);    
                        }
                        return '{' . implode(',', $result) . '}';                
                    } else {
                        foreach ($value as $key => $v) {
                            $result[] = $this -> jsonencode($v);    
                        }
                        return '[' . implode(',', $result) . ']';
                    }
                } 
}