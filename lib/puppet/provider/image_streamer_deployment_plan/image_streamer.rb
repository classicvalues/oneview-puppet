################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require_relative '../image_streamer_resource'

Puppet::Type.type(:image_streamer_deployment_plan).provide :image_streamer, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer Deployment Plan using the Image Streamer API'

  confine feature: :oneview

  mk_resource_methods

  def get_used_by
    pretty get_single_resource_instance.get_used_by
    true
  end

  def get_osdp
    pretty get_single_resource_instance.get_osdp
    true
  end
end
