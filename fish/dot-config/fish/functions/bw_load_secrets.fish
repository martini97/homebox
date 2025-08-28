function bw_load_secrets --description 'Load secrets into env vars'
    bw_unlock

    set -l gemfury_id aa854ceb-9bab-4bb8-bdcf-b347010ec4d3
    set -l gemini_id 1fbe10a8-f629-4460-9da1-b2cd0113a325

    set -gx LOADSMART_FURY_AUTH (bw get notes $gemfury_id | string trim)
    set -gx GEMINI_API_KEY (bw get password $gemini_id | string trim)
end
