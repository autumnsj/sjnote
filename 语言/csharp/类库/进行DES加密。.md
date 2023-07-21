/// 进行DES加密。

/// \</summary\>

/// \<param name=\"pToEncrypt\"\>要加密的字符串。\</pram\>

// \<param name=\"sKey\"\>密钥，且必须为8位。\</param\>

// \<returns\>以Base64格式返回的加密字符串。\</returns\>

public static string Encrypt(string pToEncryt, string sKey)

{

using (DESCryptoServicePovider des = new DESCryptoServiceProvider())

{

byte\[\] inutByteArray = Encoding.UTF8.GetBytes(pToEncrypt);

des.Key = ASCIIEncoding.UTF8.GetBytes(sKey);

des.IV = ASIIEncoding.UTF8.GetBytes(sKey);

Sstem.IO.MemoryStream ms = new System.IO.MemoryStream();

using (CryptStream cs = new CryptoStream(ms, des.CreateEncryptor(),

CryptoStreamMode.Write))

{

c.Write(inputByteArray, 0, inputByteArray.Length);

cs.FlushFinalBlock();

cs.Close();

}

string str = Convert.ToBse64String(ms.ToArray());

ms.Close();

return str;

}

}

// \<summary\>

/// 进行DES解密。

/// \</summary\>

/// \<param name=\"pToDecrypt\"\>要解密的以Base64\</param\>

/// \<param name=\"sKey\"\>密钥，且必须为8位。\</param\>

/// \<returns\>已解密的字符串。\</returns\>

public static string Decrypt(string pToDecrypt, string sKey)

{

byte\[\] inputByteArray = Convert.FromBase64String(pToDecrypt);

using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())

{

des.Key = ASCIIEncoding.UTF8.GetBytes(sKey);

des.IV = ASCIIEncoding.UTF8.GetBytes(sKey);

System.IO.MemoryStream ms = new System.IO.MemoryStream();

using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(),

CryptoStreamMode.Write))

{

cs.Write(inputByteArray, 0, inputByteArray.Length);

cs.FlushFinalBlock();

cs.Close();

}

string str = Encoding.UTF8.GetString(ms.ToArray());

ms.Close();

return str;

}

}

}

