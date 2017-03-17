defmodule Jodelx.Client do
  use HTTPoison.Base

  @base_api "api.go-tellm.com"
  @api_path "/api/v2/"
  @endpoint "https://"<> @base_api <> @api_path
  @user_agent "Jodel/4.37.2 Dalvik/2.1.0 (Linux; U; Android 6.0.1; Nexus 5 Build/MMB29V)"
  #@secret "pNsUaphGEfqqZJJIKHjfxAReDqdCTIIuaIVGaowG"
  #@secret "iyWpGGuOOCdKIMRsfxoJMIPsmCFdrscSxGyCfmBb"
  @secret "OjZvbmHjcGoPhz6OfjIeDRzLXOFjMdJmAIplM7Gq"
  @client_id "81e8a76e-1e02-4d17-9ba0-8a7020261b26"
  @client_type "android_4.37.2"
  @api_version "0.2"
  @alphabet "abcdefghijklmnopqrstuvwxyz123456789"

  defp process_url(url) do
    @endpoint <> url
  end

  def register_data(client_id, device_uid, location) do
    %{"device_uid" => device_uid,
      "location" => location,
      "client_id" => client_id}
  end

  def device_uid do
    #:crypto.strong_rand_bytes(64) |> Base.url_encode64 |> binary_part(0, 64)
    #alp = "abcdefghijklmnopqrstuvwxyz123456789" |> String.split("", trim: true)
    #Enum.reduce(1..64, [], fn (i, acc) -> [Enum.random(alp) | acc] end) |> Enum.join("")
    "bda1edc56cda91a4945b5d6e07f23449c3c18d235759952807de15b68258171f"
  end

  def iso_time do
    (NaiveDateTime.from_erl!(:calendar.local_time) |> NaiveDateTime.to_iso8601) <> "Z"
  end


  def hmac_sign(secret, message) do
    :crypto.hmac(:sha, secret, message) |> Base.encode16
  end

  def sign_request(type, path, auth, params, body, timestamp) do
    message = type <> "%" <> @base_api <> "%443%" <> @api_path <> path <> "%" <>
      auth <> "%" <> timestamp <> "%" <> params <> "%" <> body

    hmac_sign(@secret, message)
  end

  def register do
    location = %{"city" => "Oslo",
                 "loc_accuracy" => 0,
                 "loc_coordinates" => %{"lat" => 59.9139, "lng" => 10.7522}, "country" => "NO"}
    body = register_data(@client_id, device_uid, location) |> Poison.encode!

    timestamp = iso_time
    auth_header = sign_request("POST", "users/", "", "", body, timestamp)

    headers = ["X-Client-Type": @client_type,
               "X-Authorization": "HMAC " <> auth_header,
               "X-Api-Version": @api_version,
               "X-Timestamp": timestamp,
               "Accept-Encoding": "gzip, deflate",
               "Content-Type": "application/json"]

    post("users/", body, headers)
  end

  def posts(token) do
    timestamp = iso_time
    auth_header = sign_request("GET", "posts/", token, "", "", timestamp)

    headers = ["X-Client-Type": @client_type,
               "X-Authorization": "HMAC " <> auth_header,
               "X-Api-Version": @api_version,
               "X-Timestamp": timestamp,
               "Authorization": "bearer " <> token,
               "Accept-Encoding": "gzip, deflate"]

    get("posts/", headers)
  end
end
