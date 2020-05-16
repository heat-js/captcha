
import fetch 		from 'node-fetch'
import { URL } 		from 'url'

export default class RecaptchaV2

	constructor: (@secret, @origins) ->

	valid: (token, ip) ->
		if typeof token isnt 'string'
			return 0

		url = new URL 'https://www.google.com/recaptcha/api/siteverify'
		url.searchParams.set 'secret', 		@secret
		url.searchParams.set 'response', 	token
		url.searchParams.set 'remoteip',	ip

		response = await fetch url, {
			method: 'POST'
		}

		data = await response.json()

		if not @_checkValidToken data
			return false

		if not @_checkOrigin data
			return false

		return true

	_checkValidToken: (data) ->
		return data.success

	_checkOrigin: (data) ->
		if not @origins
			return true

		exists = @origins.map (origin) ->
			return -1 < origin.indexOf data.hostname

		return exists.includes true
