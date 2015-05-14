# Requires
_ = require 'lodash'

# valid csrf chars / active csrf tokens
csrf_chars = "!ABCDEFG123456789abcdefghijklmnop$"
csrf_tokens = []

# utils
module.exports = webutils = {

  # random string for anti-CSRF validation
  csrfToken: ->
    csrf = _.sample(csrf_chars, _.random(10, 15)).join("")
    csrf_tokens.push csrf
    csrf

  # true - csrf token valid (this session)
  # false - bad csrf
  checkCsrf: (check) ->
    for t, i in csrf_tokens
      if t == check
        csrf_tokens.splice 0, i
        return true

    # token did not exist
    false
}
