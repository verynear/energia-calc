module LiquidTags
  class HealthAndSafetyRecommendations < Liquid::Tag
    def render(_context)
      <<-HTML
        <table>
          <thead>
            <tr>
              <th>Health & Safety Recommendation</th>
              <th>Photograph</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <strong>Asbestos:</strong> A material that appeared to be consistent
                with asbestos was seen on your heating pipes. The material was
                damaged, raising concerns that asbestos dust has been released into
                the building. Exposure to asbestos increases the risk of lung cancer
                and mesothelioma. Contact an asbestos remediation professional to
                assess this issue. A list of licensed individuals who can test for or
                remove asbestos can be found at
                http://www.idph.state.il.us/envhealth/asbestos.htm
              </td>
              <td>
                Photograph
              </td>
            </tr>
          </tbody>
        </table>
      HTML
    end
  end
end
